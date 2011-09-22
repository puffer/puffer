module Puffer
  class Resource
    module Scoping

      def includes
        controller.index_fields.includes
      end

      def order

      end

      def searches query
        controller.index_fields.searches query
      end

    end
  end
end
