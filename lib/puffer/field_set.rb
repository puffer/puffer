module Puffer
  class FieldSet < Array

    attr_accessor :name

    def initialize name = nil
      @name = name
      super()
    end

    def field name, resource, options, &block
      push Puffer::Field.new(name, resource, self, options, &block)
      last
    end

    def columns
      select {|f| f.column}.to_fieldset
    end

    def [] key
      if key.is_a?(String) || key.is_a?(Symbol)
        detect {|f| f.field_name == key.to_s}
      else
        super
      end
    end

    def copy_to fieldset, model
      each do |f|
        new_field = fieldset.field f.field_name, model, f.options
        f.children.copy_to new_field.children, swallow_nil{new_field.reflection.klass}
      end
    end

  end
end
