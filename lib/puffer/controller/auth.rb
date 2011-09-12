module Puffer
  module Controller
    module Auth
      extend ActiveSupport::Concern

      included do
        helper_method :current_puffer_user
      end

      module InstanceMethods

        def current_puffer_user
          @current_puffer_user ||= PufferUser.find(session[:puffer_user_id]) if session[:puffer_user_id]
        end

        def require_puffer_user
          unless has_puffer_access?(namespace)
            redirect_to new_admin_session_url(:return_to => request.fullpath)
            return false
          end
        end

        def has_puffer_access? namespace
          super rescue (current_puffer_user && current_puffer_user.has_role?(namespace))
        end

      end

    end
  end
end