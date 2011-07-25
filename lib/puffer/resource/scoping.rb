module Puffer
  class Resource
    module Scoping

      def includes
        controller_class.index_fields.includes
      end

      def order

      end

      def searches query
        controller_class.index_fields.searches query
      end

    end
  end
end
