module Puffer
  module Controller
    module Mutate

      def self.included base
        base.class_eval do
          extend ClassMethods

          layout 'puffer'
          helper_method :puffer?

          self.view_paths = Puffer::PathSet.new view_paths
        end
      end

      def puffer?; true; end

      module ClassMethods

        def puffer?; true; end

      end

    end
  end
end
