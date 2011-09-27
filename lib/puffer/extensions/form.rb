module Puffer
  module Extensions
    module FormBuilder

      def puffer_field *args
        field = args.first.is_a?(Puffer::Field) ? args.first : Puffer::Field.new(*args)
        field.resource = object.class
        template = instance_variable_get :@template
        field.render template.controller, :form, :form => self, :record => object
      end

    end
  end
end

ActionView::Helpers::FormBuilder.send :include, Puffer::Extensions::FormBuilder
