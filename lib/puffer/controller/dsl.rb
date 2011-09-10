module Puffer
  module Controller
    module Dsl
      extend ActiveSupport::Concern

      included do
        class_attribute :_members
        self._members = Puffer::Controller::Actions.new :member
        class_attribute :_collections
        self._collections = Puffer::Controller::Actions.new :collection
        class_attribute :_fieldset_fallbacks
        self._fieldset_fallbacks = HashWithIndifferentAccess.new

        helper_method :_members, :_collections
      end

      module InstanceMethods
        def fields set
          self.class.fields set
        end
      end

      module ClassMethods

        def inherited klass
          klass._members = _members.dup
          klass._collections = _collections.dup
          klass._fieldset_fallbacks = Marshal.load(Marshal.dump(_fieldset_fallbacks))
          super
        end

        def member &block
          _members.controller = self
          block.bind(_members).call if block_given?
        end

        def collection &block
          _collections.controller = self
          block.bind(_collections).call if block_given?
        end

        def define_fieldset *actions
          options = actions.extract_options!
          fallbacks = Array.wrap(options.delete(:fallbacks)).map(&:to_sym)

          actions.each do |action|
            self._fieldset_fallbacks[action] = [action] + fallbacks

            class_attribute "_#{action}_fields"
            send "_#{action}_fields=", Puffer::FieldSet.new unless send("_#{action}_fields?")
            helper_method "#{action}_fields"

            self.class.instance_eval do
              define_method action do |&block|
                @_fields = send("_#{action}_fields=", Puffer::FieldSet.new(action))
                block.call if block
                remove_instance_variable :@_fields
              end

              define_method "#{action}_fields" do
                actions = self._fieldset_fallbacks[action].dup
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

        def fields set
          send "#{set}_fields"
        end

        def field name, options = {}, &block
          field = @_fields.field(name, model, options, &block) if @_fields
          #generate_association_actions field if field.reflection
        end

      end

    end
  end
end
