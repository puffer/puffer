module Puffer
  module Extensions
    module FormBuilder

      def puffer_field *args
        field = if args.first.is_a? Puffer::Fields::Field
          args.first
        else
          Puffer::Fields::Field.new object.class, *args
        end
        input = Puffer::Inputs.map_field field
        input.new(self, @template, field).render
      end

    end
  end
end

ActionView::Helpers::FormBuilder.send :include, Puffer::Extensions::FormBuilder
