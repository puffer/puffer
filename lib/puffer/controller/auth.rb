module Puffer
  module Controller
    # Module provides authentification methods and helpers for puffer
    # controllers. Puffer's authentification system is simple. In general, you
    # should use different kinds of routing and controllers namespaces for
    # partial access of different user types.
    #
    # Method +has_puffer_access?+ with current namespace name as a parameter.
    # If you want to use appication's own auth system - just redefine this
    # method in your ApplicationController.
    #
    # Also see Puffer::SessionsBase.
    module Auth
      extend ActiveSupport::Concern

      included do
        helper_method :current_puffer_user, :has_puffer_access?
      end

      # Return current user instance, used for authorization. This method can
      # be redefined in ApplicationController if you want to use application's
      # auth system.
      #
      # ex:
      #
      #   class ApplicationController < ActionController::Base
      #     def current_puffer_user
      #       current_user
      #     end
      #   end
      #
      # In this case returner user model instance should respond to has_role?
      # method, or you should properly redefine +has_puffer_access?+ See
      # +has_puffer_access?+ source and docs.
      def current_puffer_user
        @current_puffer_user ||= begin
          super
        rescue NoMethodError
          ::Admin::SessionsController.model.to_adapter.get(session[:puffer_user_id])
        end
      end

      # This method is also part of auth system and it can be redefined at the
      # ApplicationController.
      #
      # ex:
      #
      #   class ApplicationController < ActionController::Base
      #     # <tt>current_puffer_user.admin?</tt>
      #     # <tt>current_puffer_user.manager?</tt>
      #     # <tt>current_puffer_user.seo?</tt>
      #     def has_puffer_access? namespace
      #       current_puffer_user.send("#{namespace}?")
      #     end
      #   end
      def has_puffer_access? namespace
        super
      rescue NoMethodError
        (current_puffer_user && current_puffer_user.has_role?(namespace))
      end

      # Used in before_filter to prevent unauthorized access
      def require_puffer_user
        unless has_puffer_access?(puffer_namespace)
          redirect_to puffer.new_admin_session_url(:return_to => request.fullpath)
          return false
        end
      end

      def redirect_back_or default
        redirect_to(params[:return_to].presence || default)
      end
    end
  end
end