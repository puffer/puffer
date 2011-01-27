module Puffer
  module Inputs
    class File < Puffer::Inputs::Base

      def input
        builder.file_field field, field.input_options
      end

    end
  end
end
