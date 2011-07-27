module Puffer
  class Fields
    class Field

      attr_accessor :resource, :field_name, :options, :fields

      def initialize field_name, *resource_and_options, &block
        @field_name = field_name.to_s
        @options = resource_and_options.extract_options!
        @resource = resource_and_options.first
        @fields = Puffer::Fields.new
        block.bind(self).call if block
      end

      def field name, options = {}, &block
        @fields.field(name, swallow_nil{reflection.klass}, options, &block)
      end

      def native?
        model == resource
      end

      def name
        @name ||= field_name.split('.').last
      end

      def path
        @path ||= field_name.split('.')[0..-2].join('.')
      end

      def human
        @human ||= model && model.human_attribute_name(name)
      end

      def order
        @order ||= options[:order] || query_column
      end

      def type
        @type ||= options[:type] ? options[:type].to_sym : (Puffer::Customs.type_for(self) || (column ? column.type : :string))
      end

      def to_s
        field_name
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
          associations = field_name.split('.')
          associations.pop
          temp = resource
          while temp.reflect_on_association(association = swallow_nil{associations.shift.to_sym}) do
            temp = temp.reflect_on_association(association).klass
          end
          temp
        end if resource
      end

      def association_columns
        @association_columns ||= fields
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
