module Puffer
  class Resource
    class Node
      attr_accessor :parent, :children, :options

      def initialize *args
        @options = args.extract_options!
        @parent = args.first
        @children = []
        @parent.children.push self if parent
      end

      def name
        options[:name]
      end

      def to_s
        name.to_s
      end

      def namespace
        options[:namespace]
      end

      def controller
        options[:controller]
      end

      def group
        controller.configuration.group
      end

      def singular
        name.to_s.singularize
      end

      def singular?
        options[:singular]
      end

      def plural
        name.to_s.pluralize
      end

      def plural?
        !singular?
      end

      def root?
        parent.nil?
      end

      def ancestors
        ancestors = []
        resource = self
        while resource = resource.parent do
          ancestors.unshift resource
        end
        ancestors
      end

      def url_string
        [namespace, name, (:index if singular == plural)].compact.map(&:to_s).join('_')
      end

      def to_struct
        {:namespace => namespace, :current => name, :children => children.map(&:name), :ancestors => ancestors.map(&:name)}
      end
    end
  end
end