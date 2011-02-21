module Puffer
  class Fields
    class Field

      attr_accessor :resource, :field, :options

      def initialize field, *resource_and_options
        @field = field.to_s
        @options = resource_and_options.extract_options!
        @resource = resource_and_options.first
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
        @type ||= options[:type] ? options[:type].to_sym : (Puffer::Customs.type_for(self) || (column ? column.type : :string))
      end

      def to_s
        field
      end

      def reflection
        @reflection ||= model && model.reflect_on_association(name.to_sym)
      end

      def collection?
        [:has_many, :has_and_belongs_to_many].include? type
      end

      def input_options
        options[:html] || {}
      end

      def input builder
        Puffer::Customs.input_for(self).render builder, self
      end

      def model
        @model ||= begin
          associations = field.split('.')
          associations.pop
          temp = resource
          while temp.reflect_on_association(association = swallow_nil{associations.shift.to_sym}) do
            temp = temp.reflect_on_association(association).klass
          end
          temp
        end if resource
      end

      def association_columns
        raise "Can`t find records for association building. Please set :columns option for '#{field}' field." unless options[:columns].present?
        @reflection_fields ||= begin
          fields = Puffer::Fields.new
          options[:columns].each do |field_name|
            fields.field field_name, reflection.klass
          end
          fields
        end
      end

      def column
        @column ||= model && model.columns_hash[name]
      end

      def query_column
        "#{model.table_name}.#{name}" if column
      end

    end
  end
end
