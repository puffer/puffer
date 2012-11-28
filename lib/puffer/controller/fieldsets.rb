module Puffer
  module Controller
    module Fieldsets
      extend ActiveSupport::Concern

      included do

      end

      module ClassMethods
        def _fieldsets
          @_fieldsets ||= (superclass._fieldsets.inherit if superclass.respond_to?(:_fieldsets)) ||
            Puffer::Controller::Fieldsets::Register.new
        end

        def define_fieldset *actions
          options = actions.extract_options!
          actions.each{|action| define_fieldset(action, options)} and return if actions.many?

          _fieldsets.declare actions.first, options
        end
      end
    end
  end
end
