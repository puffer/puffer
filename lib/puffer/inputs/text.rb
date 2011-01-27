module Puffer
  module Inputs
    class Text < Puffer::Inputs::Base

      def input
        builder.text_area field, field.input_options
      end

    end
  end
end
