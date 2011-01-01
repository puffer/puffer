module Puffer
  module Controller
    module Mutate

      def self.included base
        base.class_eval do
          class_attribute :current_config
          self.current_config = Puffer::Controller::Config.new

          extend ClassMethods

          layout 'puffer'

          helper_method :current_resource, :current_config, :record, :records

          rescue_from ActionView::MissingTemplate do |exception|
            render current_resource.template(exception.path.split('/').last)
          end
        end
      end

      def current_resource
        @current_resource ||= Puffer::Resource.new params, request
      end

      def record
        @record || instance_variable_get("@#{current_resource.model_name}")
      end

      def records
        @records || instance_variable_get("@#{current_resource.model_name.pluralize}")
      end

      module ClassMethods

        def puffer?
          true
        end

      end

    end
  end
end
