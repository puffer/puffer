module Puffer
  class Filters
    class Diapason < Struct.new(:from, :till)
      def empty?
        from.blank? && till.blank?
      end

      def persisted?
        false
      end

      def to_query(key)
        {:from => from, :till => till}.to_query(key)
      end
    end

    include ActiveModel::Conversion
    extend ActiveModel::Naming
    extend ActiveModel::Translation
    include ActiveModel::AttributeMethods

    delegate :model_name, :special_attributes, :to => 'self.class'

    def self.special_attributes
      %w(puffer_search puffer_order)
    end

    special_attributes.each do |attribute|
      define_method attribute do
        read_attribute attribute
      end
      define_method "#{attribute}=" do |value|
        write_attribute attribute, value
      end
    end

    attr_reader :fieldset

    def initialize fieldset, attributes = {}
      @attributes = {}
      @fieldset = fieldset
      generate_attribute_methods

      self.attributes = attributes
    end

    def read_attribute name
      @attributes[name.to_s]
    end

    def write_attribute name, value
      if value.is_a? Hash
        value.each do |key, subvalue|
          @attributes[name.to_s][key] = subvalue if subvalue.present?
        end
      else
        @attributes[name.to_s] = value
      end if value.present?
    end

    def attributes

    end

    def attributes= attributes = {}
      attributes.each do |(key, value)|
        send("#{key}=", value) if respond_to?("#{key}=")
      end
    end

    def generate_attribute_methods
      fieldset.each do |field|
        define_singleton_method :"#{field}" do
          read_attribute field
        end
        define_singleton_method :"#{field}=" do |value|
          write_attribute field, value
        end

        if %(date, time, datetime, date_time, timestamp).include?(field.type.to_s)
          @attributes[field.to_s] = Puffer::Filters::Diapason.new

          define_singleton_method :"#{field}_attributes=" do |value|
            write_attribute field, value
          end
        end
      end
    end

    def query
      (fieldset.map(&:field_name) + special_attributes).reduce(ActiveSupport::HashWithIndifferentAccess.new()) do |res, attribute|
        value = send(attribute)
        attribute = "#{attribute}_attributes" if respond_to?("#{attribute}_attributes=")
        res[attribute] = value unless value.blank?
        res
      end
    end

    def conditions
      fieldset.map(&:field_name).reduce(ActiveSupport::HashWithIndifferentAccess.new()) do |res, attribute|
        value = send(attribute)

        unless value.blank?
          value = case value
          when 'puffer_nil' then nil
          when 'puffer_blank' then ''
          else value
          end
          res[attribute] = value
        end

        res
      end
    end

    def search
      puffer_search
    end

    def order
      puffer_order.to_s.split(' ').map(&:to_sym)
    end

    def persisted?
      false
    end

  end
end