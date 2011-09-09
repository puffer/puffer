module Puffer
  module Extensions
    module ActionController
      module Base
        extend ActiveSupport::Concern

        included do
          extend ClassMethods

          helper_method :puffer?, :render_component
        end

        module ClassMethods
          def puffer?; false; end

          def pufferize!
            include Puffer::Controller::Mutate
            include Puffer::Controller::Helpers
            include Puffer::Controller::Dsl
            include Puffer::Controller::Config
          end
        end

        module InstanceMethods
          def puffer?; false; end

          def render_component *args
            Puffer::Component::Base.render_component self, *args
          end
        end

      end
    end
  end
end

ActionController::Base.send :include, Puffer::Extensions::ActionController::Base
