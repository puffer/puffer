module Puffer
  class Filters
    include ActiveModel::Conversion
    extend ActiveModel::Naming
    extend ActiveModel::Translation
    include ActiveModel::AttributeMethods

    delegate :model_name, :to => 'self.class'

    def initialize attributes = {}
      @ranges = {}
      attributes ||= {}
      attributes.each do |(key, value)|
        send("#{key}=", value) if respond_to?("#{key}=")
      end
    end

    def read_attribute name
      range = @ranges[name]
      if range.is_a?(Hash) && range.values.any?
        range
      else
        attributes[name]
      end
    end

    def write_attribute name, value
      attributes[name] = value.presence if attributes.key?(name)
    end

    def persisted?
      false
    end

    def any?
      attributes.keys.any? { |attribute| !send(attribute).nil? }
    end

    def conditions
      attributes.except('puffer_search', 'puffer_order').keys.reduce(ActiveSupport::HashWithIndifferentAccess.new()) do |res, attribute|
        value = send(attribute)

        unless value.nil?
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

    def query
      attributes.keys.reduce(ActiveSupport::HashWithIndifferentAccess.new()) do |res, attribute|
        value = send(attribute)
        res[attribute] = value unless value.nil?
        res
      end
    end

    module ClassMethods
      def model_name
        @model_name ||= begin
          name = super
          name.instance_variable_set :@param_key, 'filters'
          name
        end
      end

      def controller_filters controller
        scope = "#{controller}Filters".split('::')[0..-2].join('::').constantize rescue Kernel
        name = "#{controller}Filters".demodulize

        if scope.const_defined?(name)
          scope.const_get(name)
        else
          attributes_from_controller = controller.filter_fields.reduce(ActiveSupport::HashWithIndifferentAccess.new()) do |res, field|
            res[field.field_name] = nil
            res
          end

          klass = Class.new(self)

          attributes_from_controller.keys.each do |name|
            klass.send :define_method, "#{name}_from" do
              swallow_nil{@ranges[name][:from].presence}
            end
            klass.send :define_method, "#{name}_from=" do |value|
              @ranges[name] ||= {:from => nil, :till => nil}
              @ranges[name][:from] = value
            end
            klass.send :define_method, "#{name}_till" do
              swallow_nil{@ranges[name][:till].presence}
            end
            klass.send :define_method, "#{name}_till=" do |value|
              @ranges[name] ||= {:from => nil, :till => nil}
              @ranges[name][:till] = value
            end
          end

          attributes_from_controller.merge!('puffer_search' => nil, 'puffer_order' => nil)

          attributes_from_controller.keys.each do |name|
            klass.send :define_method, name do
              read_attribute name
            end
            klass.send :define_method, "#{name}=" do |value|
              write_attribute name, value
            end
          end

          klass.send :define_method, :attributes do
            attributes_from_controller
          end
          
          scope.const_set(name, klass)
        end
      end
    end

    extend ClassMethods

  end
end