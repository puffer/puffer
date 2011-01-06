module Puffer
  module Controller
    module Helpers

      def self.included base
        base.class_eval do
          include InstanceMethods
          extend ClassMethods

          helper_method :resource_session, :puffer_navigation, :resource, :record, :records
        end
      end

      module ClassMethods

        def model_name
          @model_name ||= (configuration.model || controller_name.singularize).to_s
        end

        def model
          @model ||= model_name.classify.constantize rescue nil
        end

      end

      module InstanceMethods

        def puffer_navigation
          Rails.application.routes.puffer[resource.prefix].values.map(&:first).each do |controller|
            title = controller.configuration.group.to_s.humanize
            path = send("#{resource.prefix}_#{controller.controller_name}_path")
            current = configuration.group == controller.configuration.group
            yield title, path, current
          end
        end

        def resource_session
          postfix = params[:action] =~ /associated_/ ? params[:action] : ''
          name = "#{resource.model_name}#{postfix}".to_sym
          session[:resources] ||= {}
          session[:resources][name] ||= {}
          session[:resources][name][:boolean] ||= {}
          session[:resources][name]
        end

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
