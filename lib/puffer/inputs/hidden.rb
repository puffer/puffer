module Puffer
  module Inputs
    class Hidden < Puffer::Inputs::Base

      def input
        builder.hidden_field field, field.input_options
      end

    end
  end
end
