module Puffer
  module Extensions
    module ActionController
      module Base
        extend ActiveSupport::Concern

        included do
          delegate :puffer?, :to => 'self.class'
          helper_method :puffer?
        end

        module ClassMethods
          def puffer?
            false
          end

          def pufferize!
            include Puffer::Controller::Mutate
            include Puffer::Controller::Dsl
            include Puffer::Controller::Config
          end
        end

      end
    end
  end
end

ActionController::Base.send :include, Puffer::Extensions::ActionController::Base
