module Puffer
  module Controller
    module Helpers

      def self.included base
        base.class_eval do
          helper_method :resource_session, :searchable_fields, :boolean_fields, :puffer_navigation
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

      def searchable_fields fields
        @searchable_fields ||= fields.map { |f| f if [:text, :string, :integer, :decimal, :float].include? f.type }.compact
      end

      def boolean_fields
        @boolean_fields ||= index_fields.map { |f| f if ['boolean'].include? f.type.to_s }.compact
      end

    end
  end
end
