module Puffer
  module Controller
    module Dsl

      def self.included base
        base.class_eval do
          extend ClassMethods
          include ActionMethods
          extend ActionMethods

          %w(index show form create update).each do |action|
            class_attribute "_#{action}_fields"
            send "_#{action}_fields=", Puffer::Fields.new unless send("_#{action}_fields").present?
            helper_method "#{action}_fields"
          end
        end
      end

      module ClassMethods

        %w(index show form create update).each do |action|
          define_method action do |&block|
            @_fields = send "_#{action}_fields"
            @_fields.clear
            block.call if block
            @_fields = nil
          end
        end

        def field name, options = {}
          field = @_fields.field(model, name, options) if @_fields
          #generate_association_actions field if field.association?
          #generate_change_actions field if field.toggable?
        end

      end

      module ActionMethods

        def index_fields
          _index_fields
        end

        def show_fields
          _show_fields.presence || _index_fields
        end

        def form_fields
          _form_fields
        end

        def create_fields
          _create_fields.presence || _form_fields
        end

        def update_fields
          _update_fields.presence || _form_fields
        end

      end

    end
  end
end
