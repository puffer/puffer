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
        new_polymorphic_url *route_args(name.to_s.singularize, *args)
      end

      def edit_url *args
        suggest = args.shift if args.first.respond_to? :to_key
        edit_polymorphic_url *route_args(route_member(suggest), *args)
      end

      def route_args *args
        options = args.extract_options!
        resource = Array.wrap(args)
        return [scope] + ancestors.map(&:route_member) + resource, options
      end

      def route_member suggest = nil
        plural? ? (suggest || member) : name.to_s.singularize
      end

      def default_url_options *args
        Puffer::Base.default_url_options(*args)
      end

    end
  end
end
