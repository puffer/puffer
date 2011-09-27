module Puffer
  class Filters
    include ActiveModel::Conversion
    extend ActiveModel::Naming
    extend ActiveModel::Translation
    include ActiveModel::AttributeMethods

    delegate :model_name, :to => 'self.class'

    def initialize attributes = {}
      attributes ||= {}
      attributes.each do |(key, value)|
        send("#{key}=", value) if respond_to?("#{key}=")
      end
    end

    def read_attribute name
      attributes[name]
    end

    def write_attribute name, value
      attributes[name] = value if attributes.key?(name)
    end

    def persisted?
      false
    end

    def to_query
      {model_name.param_key => attributes}
    end

    def search
      puffer_search
    end

    def conditions
      attributes.except('puffer_search', 'puffer_order').keys.reduce({}) do |res, attribute|
        res[attribute] = send(attribute)
        res
      end
    end

    def order
      puffer_order
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
          attributes_from_controller = controller.index_fields.reduce({}) do |res, field|
            res[field.field_name] = nil
            res
          end

          attributes_from_controller.merge!('puffer_search' => nil, 'puffer_order' => nil)

          klass = Class.new(self)

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
          klass.send :define_method, :name do
            controller.controller_name
          end

          scope.const_set(name, klass)
        end
      end
    end

    extend ClassMethods

  end
end