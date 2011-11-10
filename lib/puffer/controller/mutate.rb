module Puffer
  module Controller
    module Mutate
      extend ActiveSupport::Concern

      included do
        helper 'puffer/helpers/puffer'
        
        delegate :model, :model_name, :to => 'self.class'
        helper_method :puffer_filters, :puffer_namespace, :resource, :record, :records
      end

      module InstanceMethods

        def process_action method_name, *args
          params[:puffer] = Rails.application.routes.resources_tree[params[:puffer]] if params[:puffer]
          super
        end

        def puffer_filters
          @puffer_filters ||= begin
            filters = params[Puffer::Filters.model_name.param_key] || {}
            filters = {:puffer_order => configuration.order}.merge(filters) if configuration.order.present?
            Puffer::Filters.new filter_fields, filters
          end
        end

        def puffer_namespace
          resource.scope
        end

        def resource
          @resource ||= Puffer::Resource.new params, self
        end

        def record
          @record || instance_variable_get("@#{resource.model_name}")
        end

        def records
          @records || instance_variable_get("@#{resource.model_name.pluralize}")
        end

      end

      module ClassMethods

        def puffer?
          true
        end

        def model_name
          @model_name ||= (configuration.model_name || controller_name.singularize).to_s
        end

        def model
          @model ||= model_name.camelize.constantize rescue nil
        end

      end

    end
  end
end
