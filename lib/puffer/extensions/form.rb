module Puffer
  module Extensions
    module FormBuilder

      def puffer_field field
        input = Puffer::Inputs.map_field field
        input.new(self, @template, field).render
      end

    end
  end
end

ActionView::Helpers::FormBuilder.send :include, Puffer::Extensions::FormBuilder
