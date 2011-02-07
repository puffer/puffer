module Puffer
  module Controller
    module Mutate

      def self.included base
        base.class_eval do
          extend ClassMethods

          layout 'puffer'
          helper :puffer
          helper_method :puffer?

          view_paths_fallbacks :puffer
        end
      end

      def puffer?; true; end

      module ClassMethods

        def model_name
          @model_name ||= ((puffer? and configuration.model) || controller_name.singularize).to_s
        end

        def model
          @model ||= model_name.classify.constantize if model_name.present?
        end

        def view_paths_fallbacks *args
          temp = Puffer::PathSet.new view_paths
          temp._fallbacks = args.flatten
          self.view_paths = temp
        end

        def view_paths_fallbacks_prepend *args
          view_paths_fallbacks args, view_paths._fallbacks
        end

        def view_paths_fallbacks_append *args
          view_paths_fallbacks view_paths._fallbacks, args
        end

        def puffer?; true; end

      end

    end
  end
end
