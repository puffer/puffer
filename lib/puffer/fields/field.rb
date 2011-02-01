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
        @name ||= field.split('.').last
      end

      def path
        @path ||= field.split('.')[0..-2].join('.')
      end

      def label
        @label ||= resource.human_attribute_name(field)
      end

      def order
        @order ||= options[:order] || query_column
      end

      def type
        @type ||= options[:type] ? options[:type].to_sym : (Puffer::Fields.offered_type(self) || (column ? column.type : :string))
      end

      def to_s
        field
      end

      def reflection
        @reflection ||= model.reflect_on_association(name.to_sym)
      end

      def collection?
        [:has_many, :has_and_belongs_to_many].include? type
      end

      def input_options
        {}
      end

      def model
        unless @model
          @model = resource
          associations = field.split('.')
          associations.pop
          while @model.reflect_on_association(association = swallow_nil{associations.shift.to_sym}) do
            @model = @model.reflect_on_association(association).klass
          end
        end
        @model
      end

      def association_fields
        raise "Can`t find records for association building. Please set :search_fields option for '#{field}' field." unless options[:search_fields].present?
        @reflection_fields ||= begin
          fields = Puffer::Fields.new
          options[:search_fields].each do |field_name|
            fields.field reflection.klass, field_name
          end
          fields
        end
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
