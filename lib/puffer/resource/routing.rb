module Puffer
  class Resource
    module Routing

      include ActionController::UrlFor
      include Rails.application.routes.url_helpers

      def collection_url *args
        polymorphic_url *route_args(route_member(model), *args)
      end

      def member_url *args
        suggest = args.shift if args.first.respond_to? :to_key
        polymorphic_url *route_args(route_member(suggest), *args)
      end

      def new_url *args
        new_polymorphic_url *route_args(controller_name.singularize, *args)
      end

      def edit_url *args
        p args
        suggest = args.shift if args.first.respond_to? :to_key
        edit_polymorphic_url *route_args(route_member(suggest), *args)
      end

      def route_args *args
        options = args.extract_options!
        resource = args.shift
        return args + [namespace] + ancestors.map(&:route_member) + [resource], options
      end

      def route_member suggest = nil
        plural? ? (suggest || member) : controller_name.singularize
      end

      def default_url_options *args
        Puffer::Base.default_url_options(*args)
      end

    end
  end
end
