module Puffer
  class Fields
    class Field

      attr_accessor :resource, :field, :options

      def initialize resource, field, options = {}
        @resource = resource
        @field = field.to_s
        @options = options
      end

      def native?
        model == resource
      end

      def name
        field.split('.').last
      end

      def label
        @label ||= options[:label] || model.human_attribute_name(name)
      end

      def order
        @order ||= options[:order] || query_column
      end

      def type
        @type ||= options[:type] ? options[:type].to_sym : (column ? column.type : :string)
      end

      def to_s
        field
      end

      def model
        unless @model
          @model = resource
          associations = field.split('.')
          while @model.reflect_on_association(association = associations.shift.to_sym) do
            @model = @model.reflect_on_association(association).klass
          end
        end
        @model
      end

      def column
        @column ||= model.columns_hash[name]
      end

      def query_column
        "#{model.table_name}.#{name}" if column
      end

    end
  end
end
