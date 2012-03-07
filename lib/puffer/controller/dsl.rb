module Puffer
  module Controller
    module Dsl

      module Fieldsets
        extend ActiveSupport::Concern

        included do
          delegate :fields, :to => 'self.class'
        end

        module ClassMethods
          def define_fieldset *actions
            options = actions.extract_options!
            return actions.each{|action| define_fieldset(action, options)} if actions.many?

            fallbacks = Array.wrap(options[:fallbacks]).map(&:to_sym)

            action = actions.first
            self._fieldset_fallbacks[action] = [action] + fallbacks

            class_attribute "_#{action}_fields"
            send "_#{action}_fields=", Puffer::Fieldset.new(action, model) unless send("_#{action}_fields?")
            delegate "#{action}_fields", :to => 'self.class'
            helper_method "#{action}_fields"

            define_fieldset_reader_for action
            define_fieldset_writer_for action
          end

          def define_fieldset_reader_for action
            self.class.instance_eval do
              define_method "#{action}_fields" do
                actions = self._fieldset_fallbacks[action].dup
                last = actions.pop
                actions.map do |action|
                  send("_#{action}_fields").presence
                end.compact.first || send("_#{last}_fields")
              end
            end
          end

          def define_fieldset_writer_for action
            self.class.instance_eval do
              define_method action do |&block|
                @_super_fields = send("_#{action}_fields")
                @_fields = send("_#{action}_fields=", Puffer::Fieldset.new(action, model))
                block.call if block
                remove_instance_variable :@_fields
                remove_instance_variable :@_super_fields
              end
            end
          end

          def fields set
            send "#{set}_fields"
          end

          def super_fields
            @_super_fields.copy_to @_fields, model if @_super_fields && @_fields
          end

          def field name, options = {}, &block
            field = @_fields.field(name, options, &block) if @_fields
            if field && block
              fields_was, @_fields = @_fields, field.children
              block.call
              @_fields = fields_was
            end
            field
          end

        end
      end

      extend ActiveSupport::Concern
      include Fieldsets

      included do
        class_attribute :_members
        self._members = Puffer::Controller::Actions.new :member
        class_attribute :_collections
        self._collections = Puffer::Controller::Actions.new :collection
        class_attribute :_fieldset_fallbacks
        self._fieldset_fallbacks = HashWithIndifferentAccess.new

        helper_method :_members, :_collections
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
      end
    end
  end
end
