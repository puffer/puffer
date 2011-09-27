module Puffer
  class Resource
    module Scoping

      def searches query
        controller.index_fields.searches query
      end

    end
  end
end
