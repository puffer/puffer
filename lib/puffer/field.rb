module Puffer
  class Field

    attr_accessor :field_name, :fieldset, :options

    def initialize fieldset, field_name, options = {}
      @fieldset, @field_name, @options = fieldset, field_name.to_s, options
      @fieldset.push(self)
    end

    def children
      model = reflection ? reflection.klass : fieldset.model
      @children ||= Puffer::Fieldset.new "#{fieldset.name}:#{field_name}", model
    end

    def native?
      model == fieldset.model
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
      @human ||= options[:title] || (model && model.human_attribute_name(name))
    end

    def type
      @type ||= options[:type] || custom_type || column_type || :string
    end

    def custom_type
      Puffer.field_type_for self
    end

    def sort
      column ? field_name : options[:sort]
    end

    def reflection
      @reflection ||= model && model.to_adapter.reflection(name)
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
        temp = fieldset.model
        while temp.reflect_on_association(association = swallow_nil{associations.shift.to_sym}) do
          temp = temp.reflect_on_association(association).klass
        end
        temp
      end if fieldset.model
    end

    def column
      @column ||= model && model.to_adapter.columns_hash[name]
    end

    def column_type
      reflection.macro if reflection
      column[:type] if column
    end

  end
end
