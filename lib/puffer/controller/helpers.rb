module Puffer
  module Controller
    module Helpers

      def self.included base
        base.class_eval do
          helper_method :resource_session, :puffer_navigation
        end
      end

      def puffer_navigation

      end

      def resource_session
        postfix = params[:action] =~ /associated_/ ? params[:action] : ''
        name = "#{current_resource.model_name}#{postfix}".to_sym
        session[:resources] ||= {}
        session[:resources][name] ||= {}
        session[:resources][name][:boolean] ||= {}
        session[:resources][name]
      end

    end
  end
end
