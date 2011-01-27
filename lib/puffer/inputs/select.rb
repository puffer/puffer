module Puffer
  module Inputs
    class Select < Puffer::Inputs::Base

      def input
        builder.select field, field.options[:select], field.input_options
      end

    end
  end
end
