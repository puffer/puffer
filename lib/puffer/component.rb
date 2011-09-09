module Puffer
  module Component

    # <tt>Puffer::Component::Base</tt> is a base component low-level for puffer
    # fields. It provides all the base functionality for rendering visual fields
    # components.
    # Every component belongs to field by field's type
    # Every component should have some basic actions, based on parent controller
    # fieldsets, so they can be fallbacked as fieldsets.
    #
    # Also, every component can have additional actions for ajax requests
    # handling and component state changing
    class Base < AbstractController::Base

      module ComponentHelper
        def component_wrap name = :span, options = {}, &block
          content_tag name, options.merge(:id => component_id), &block
        end

        def clean_content_for name, *args, &block
          @view_flow.set name, ''
          content_for name, *args, &block
        end

        def paginate(scope, options = {}, &block)
          paginator = Kaminari::Helpers::Paginator.new parent_controller.view_context, options.reverse_merge(:current_page => scope.current_page, :num_pages => scope.num_pages, :per_page => scope.limit_value, :param_name => Kaminari.config.param_name, :remote => false)
          paginator.to_s
        end
      end

      module SingletonMethods
        def render_component parent_controller, field, context, *args
          klass = "#{field.type}_component".camelize.constantize rescue StringComponent
          component = klass.new field
          component.process parent_controller, context, *args
        end
      end

      module ClassMethods
        def controller_path
          @controller_path ||= name.sub(/Component$/, '').underscore unless anonymous?
        end
      end

      abstract!

      include AbstractController::Rendering
      include AbstractController::Helpers
      include AbstractController::Translation
      include AbstractController::Logger
      include AbstractController::Layouts

      include ActionController::RequestForgeryProtection
      include ActionController::UrlFor
      include Rails.application.routes.url_helpers

      extend SingletonMethods
      extend ClassMethods

      helper ComponentHelper, PufferHelper

      attr_accessor :parent_controller, :field, :opts, :identifer
      delegate :env, :request, :params, :session, :resource, :_members, :_collections, :to => :parent_controller
      helper_method :params, :session, :resource, :_members, :_collections, :parent_controller, :field, :opts, :identifer, :component_id, :event_url, :event_path, :record, :records

      def initialize field
        super()
        @field = field
      end

      def process parent_controller, context, *args
        @parent_controller = parent_controller
        @identifer = params[:identifer] || generate_identifer
        super context, *args
      end

      def send_action method_name, *args
        @opts = args.extract_options!
        send method_name, *args
      end

      def render *args, &block
        options = _normalize_render(*args, &block)
        options[:template] = fallback_action(options[:template])
        render_to_body(options).html_safe
      end

      def replace *args
        javascript_wrap :replace, render(*args)
      end

      def javascript_wrap type, html
        case type
        when :replace then
          "$('#{component_id}').replace('#{view_context.escape_javascript html}')".html_safe
        else
          html
        end
      end

      def method_for_action action_name
        fallback_action(action_name) || super
      end

      def fallback_action action_name
        ((parent_controller._fieldset_fallbacks[action_name] || []).detect {|name| action_method? name.to_s} || action_name).to_s
      end

      def event_url name, options = {}
        resource.collection_url :event, (options || {}).merge(event_options(name))
      end

      def event_path name, options = {}
        resource.collection_path :event, (options || {}).merge(event_options(name))
      end

      def event_options name
        {:event => name, :field => field.to_s, :fieldset => field.field_set.name, :identifer => identifer}
      end

      def record
        @record || instance_variable_get("@#{resource.model_name}")
      end

      def records
        @records || instance_variable_get("@#{resource.model_name.pluralize}")
      end

      def component_id
        @component_id ||= "component_#{identifer}"
      end

    private

      def generate_identifer
        Digest::MD5.hexdigest(SecureRandom.uuid)
      end

    end
  end
end
