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
            send "_#{action}_fields=", Puffer::Fields.new unless send("_#{action}_fields?")
            helper_method "#{action}_fields"
          end

          class_attribute :_members
          self._members = Puffer::Controller::Actions.new
          class_attribute :_collections
          self._collections = Puffer::Controller::Actions.new
        end
      end

      module ClassMethods

        def inherited klass
          klass._members = _members.dup
          klass._collections = _collections.dup
          super
        end

        def member &block
          block.bind(_members).call if block_given?
        end

        def collection &block
          block.bind(_collections).call if block_given?
        end

        %w(index show form create update).each do |action|
          define_method action do |&block|
            @_fields = send("_#{action}_fields=", Puffer::Fields.new)
            block.call if block
            remove_instance_variable :@_fields
          end
        end

        def field name, options = {}
          field = @_fields.field(model, name, options) if @_fields
          generate_association_actions field if field.reflection
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
