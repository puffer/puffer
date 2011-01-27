module Puffer
  module Inputs
    class Association < Puffer::Inputs::Base

      def input
        field.type
      end

    end
  end
end
