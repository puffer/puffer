module Puffer
  module Component
    class TestCase < ActiveSupport::TestCase
      module Behavior
        # include Puffer::Controller::Dsl::Fieldsets
        extend ActiveSupport::Concern

        included do
          class_attribute :_component_class, :_model_class
          class_attribute :_field
          attr_reader :component, :controller
          setup :setup_component_and_controller

          delegate :model, :to => 'self.class'
        end

        def setup_component_and_controller
          if self.class.component_class && _field
            @component ||= self.class.component_class.new(_field)
          end

          @request = ActionController::TestRequest.new
          @response = ActionController::TestResponse.new

          controller_class = Class.new(Puffer::Base)
          controller_class.singleton_class.class_eval do
            def name; "AnonymousController" end
          end
          @controller = controller_class.new

          @controller.request = @request
          @controller.params = {}
        end

        def process action, record, parameters = {}
          [:@component, :@controller, :@request, :@response].each do |variable|
            unless instance_variable_get(variable)
              raise "#{variable} is nil: make sure you have initialized it."
            end
          end

          @controller.response_body = nil
          @controller.formats = nil
          @controller.params = nil
          @controller.params.merge!(parameters)

          @component.process(action, @controller, record)
        end

        module ClassMethods
          def component_class= new_class
            self._component_class = new_class
          end

          def component_class
            self._component_class ||= determine_default_component_class(name)
          end

          def determine_default_component_class(name)
            name.sub(/Test$/, '').constantize
          end

          def model new_class = nil
            new_class ? self._model_class = new_class : self._model_class
          end

          def field name, options = {}, &block
            @_fields ||= Puffer::Fieldset.new 'default', _model_class

            field = @_fields.field(name, options, &block) if @_fields
            if field && block
              fields_was, @_fields = @_fields, field.children
              block.call
              @_fields = fields_was
            end
            self._field = field
          end
        end
      end

      include Behavior
    end
  end
end
