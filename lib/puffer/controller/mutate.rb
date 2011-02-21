module Puffer
  module Controller
    module Mutate

      def self.included base
        base.class_eval do
          extend ClassMethods
          include InstanceMethods

          layout 'puffer'
          helper :puffer
          helper_method :puffer?, :namespace
        end
      end

      module InstanceMethods

        def puffer?
          self.class.puffer?
        end

        def namespace
          self.class.namespace
        end

      end

      module ClassMethods

        def puffer?
          true
        end

        def namespace
          to_s.underscore.split('/').first
        end

        def model_name
          @model_name ||= (configuration.model_name || controller_name.singularize).to_s
        end

        def model
          @model ||= model_name.camelize.constantize rescue nil
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

      end

    end
  end
end
