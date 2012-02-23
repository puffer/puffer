module Puffer
  class Fieldset < Array

    attr_accessor :name, :model

    def initialize name, model = nil
      @name, @model = name, model
      super()
    end

    def field name, options = {}
      Puffer::Field.new(self, name, options)
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

    def copy_to target, model
      each do |old_field|
        new_field = target.field old_field.field_name, old_field.options
        old_field.children.copy_to new_field.children, swallow_nil{new_field.reflection.klass}
      end
    end

  end
end
