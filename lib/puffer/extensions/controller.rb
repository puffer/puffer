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
            included_modules.include? Puffer::Controller
          end
        end

      end
    end
  end
end

ActionController::Base.send :include, Puffer::Extensions::ActionController::Base
