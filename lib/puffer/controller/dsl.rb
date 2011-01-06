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
            helper_method "#{action}_fields"
          end
        end
      end

      module ClassMethods

        %w(index show form create update).each do |action|
          define_method action do
            send "_#{action}_fields=", Puffer::Fields.new
            @_fields = action
            yield if block_given?
          end
        end

        def field name, options = {}
          field = @_fields.field(model, name, options)
          #generate_association_actions field if field.association?
          #generate_change_actions field if field.toggable?
        end

      end

      module ActionMethods

        def index_fields
          _index_fields || Puffer::Fields.new
        end

        def show_fields
          _show_fields || _index_fields || Puffer::Fields.new
        end

        def form_fields
          _form_fields || Puffer::Fields.new
        end

        def create_fields
          _create_fields || _form_fields || Puffer::Fields.new
        end

        def update_fields
          _update_fields || _form_fields || Puffer::Fields.new
        end

      end

    end
  end
end
