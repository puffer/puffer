module Puffer
  module Extensions
    module FormBuilder

      def puffer_field *args
        field = if args.first.is_a? Puffer::Fields::Field
          args.first
        else
          options = args.extract_options!
          Puffer::Fields::Field.new args, options
        end
        field.resource = object.class
        input = Puffer::Inputs.map_field field
        input.new(self, @template, field).render
      end

    end
  end
end

ActionView::Helpers::FormBuilder.send :include, Puffer::Extensions::FormBuilder
