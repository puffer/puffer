module Puffer
  module Controller
    module Dsl

      def self.included base
        base.class_eval do
          extend ClassMethods

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

        def define_fieldset *actions
          options = actions.extract_options!
          fallbacks = Array.wrap(options.delete(:fallbacks))

          actions.each do |action|
            class_attribute "_#{action}_fields"
            send "_#{action}_fields=", Puffer::FieldSet.new unless send("_#{action}_fields?")
            helper_method "#{action}_fields"

            self.class.instance_eval do
              define_method action do |&block|
                @_fields = send("_#{action}_fields=", Puffer::FieldSet.new)
                block.call if block
                remove_instance_variable :@_fields
              end

              define_method "#{action}_fields" do
                actions = [action] + fallbacks
                last = actions.pop
                actions.map do |action|
                  send("_#{action}_fields").presence
                end.compact.first || send("_#{last}_fields")
              end
            end

            define_method "#{action}_fields" do
              self.class.send "#{action}_fields"
            end
          end
        end

        def field name, options = {}, &block
          field = @_fields.field(name, model, options, &block) if @_fields
          generate_association_actions field if field.reflection
          #generate_change_actions field if field.toggable?
        end

      end

    end
  end
end
