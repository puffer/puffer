module Puffer
  class Resource
    class Tree
      attr_accessor :nodes

      def initialize
        @nodes = []
      end

      def append_node *args
        options = args.extract_options!
        parent = args.first

        parent = case parent
        when Integer then
          nodes[parent]
        when Puffer::Resource::Node, nil then
          parent
        else
          return
        end

        push Puffer::Resource::Node.new(parent, options)
        size.pred
      end

      def roots
        nodes.select &:root?
      end

      def method_missing method, *args, &block
        nodes.send method, *args, &block if nodes.respond_to? method
      end
    end
  end
end