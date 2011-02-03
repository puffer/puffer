module Puffer
  module Inputs
    class Password < Puffer::Inputs::Base

      def input
        builder.hidden_field field, field.input_options
      end

    end
  end
end
