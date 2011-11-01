module Puffer
  class Field

    attr_accessor :resource, :field_name, :field_set, :options, :children

    def initialize field_name, resource, *fieldset_and_options, &block
      @field_name = field_name.to_s
      @resource = resource
      @options = fieldset_and_options.extract_options!  
      @field_set = fieldset_and_options.first
      @children = Puffer::FieldSet.new swallow_nil{field_set.name}
      block.bind(self).call if block
    end

    def field name, options = {}, &block
      @children.field(name, swallow_nil{reflection.klass}, options, &block)
    end

    def native?
      model == resource
    end

    def to_s
      field_name
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

    def type
      @type ||= options[:type] || custom_type || column_type || :string
    end

    def custom_type
      Puffer.field_type_for self
    end

    def reflection
      @reflection ||= model && model.reflect_on_association(name.to_sym)
    end

    def input_options
      options[:html] || {}
    end

    def component_class
      @component_class ||= Puffer.component_for self
    end

    def component
      @component ||= component_class.new self
    end

    def render context, controller, *record_and_options
      options = record_and_options.extract_options!
      component.process context, controller, record_and_options.first, options
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

    def column
      @column ||= model && model.to_adapter.columns_hash[name]
    end

    def column_type
      column[:type] if column
    end

  end
end
