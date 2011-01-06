module Puffer
  module Controller
    module Mutate

      def self.included base
        base.class_eval do
          extend ClassMethods

          layout 'puffer'

          rescue_from ActionView::MissingTemplate do |exception|
            render resource.template(exception.path.split('/').last)
          end
        end
      end

      module ClassMethods

        def puffer?
          true
        end

      end

    end
  end
end
