module Puffer
  module Controller
    module Mutate
      extend ActiveSupport::Concern

      included do
        layout 'puffer'
        helper :puffer
        delegate :namespace, :model, :model_name, :to => 'self.class'
        helper_method :namespace, :resource, :record, :records
      end

      module InstanceMethods

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

        def namespace
          to_s.underscore.split('/').first
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
