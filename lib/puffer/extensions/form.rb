module Puffer
  module Extensions
    module FormBuilder

      def puffer_field *args
        field = args.first.is_a?(Puffer::Field) ? args.first : Puffer::Field.new(*args)
        field.resource = object.class
        field.input self
      end

    end
  end
end

ActionView::Helpers::FormBuilder.send :include, Puffer::Extensions::FormBuilder
