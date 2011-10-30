module Puffer
  class Resource
    module Routing

      include ActionController::UrlFor
      include Rails.application.routes.url_helpers

      def collection_method routing_type, options = {}
        send url_method_name(routing_type, url_segment, options.delete(:action)), *url_arguments, options
      end

      def member_method routing_type, *args
        options = args.extract_options!
        send url_method_name(routing_type, singular, options.delete(:action)), *url_arguments(args.first || params[:id]), options
      end

      def new_method routing_type, options = {}
        send url_method_name(routing_type, singular, :new), *url_arguments, options
      end

      def edit_method routing_type, *args
        options = args.extract_options!
        member_method routing_type, *args, options.merge(:action => :edit)
      end

      def url_method_name routing_type, current, action = nil
        [action, scope, *ancestors.map(&:singular), current, routing_type].compact.join('_')
      end

      def url_arguments current = nil
        ancestors.map(&:member_id).push(current).compact
      end

      %w(url path).each do |routing_type|
        %w(collection member new edit).each do |method|
          define_method "#{method}_#{routing_type}" do |*args|
            send "#{method}_method", routing_type, *args
          end
        end
      end

      def default_url_options *args
        Puffer::Base.default_url_options(*args)
      end

    end
  end
end
