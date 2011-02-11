module Puffer
  module Controller
    module Helpers

      def self.included base
        base.class_eval do
          include InstanceMethods

          helper_method :resource_session, :resource, :record, :records
        end
      end

      module InstanceMethods

        def resource
          @resource ||= Puffer::Resource.new params, request
        end

        def record
          @record || instance_variable_get("@#{resource.model_name}")
        end

        def records
          @records || instance_variable_get("@#{resource.model_name.pluralize}")
        end

      end

    end
  end
end
