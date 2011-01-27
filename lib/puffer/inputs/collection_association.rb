module Puffer
  module Inputs
    class CollectionAssociation < Puffer::Inputs::Base

      def input
        field.type
      end

    end
  end
end
