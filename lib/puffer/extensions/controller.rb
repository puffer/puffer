module Puffer
  module Extensions
    module ActionController
      module Base

        def self.included base
          base.class_eval do
            extend ClassMethods

            helper_method :puffer?
          end
        end

        def puffer?; false; end

        module ClassMethods

          def puffer?; false; end

          def pufferize!
            include Puffer::Controller::Mutate
            include Puffer::Controller::Helpers
            include Puffer::Controller::Dsl
            include Puffer::Controller::Mapping
            include Puffer::Controller::Config
            include Puffer::Controller::Generated
          end

        end

      end
    end
  end
end

ActionController::Base.send :include, Puffer::Extensions::ActionController::Base
