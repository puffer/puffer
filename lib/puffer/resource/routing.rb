module Puffer
  class Resource
    module Routing

      include ActionController::UrlFor
      include Rails.application.routes.url_helpers

      def collection_url *args
        polymorphic_url *route_args(route_member(controller_name), *args)
      end

      def member_url *args
        suggest = args.shift if args.first.is_a? ActiveRecord::Base
        polymorphic_url *route_args(route_member(suggest), *args)
      end

      def new_url *args
        new_polymorphic_url *route_args(controller_name.singularize, *args)
      end

      def edit_url *args
        suggest = args.shift if args.first.is_a? ActiveRecord::Base
        edit_polymorphic_url *route_args(route_member(suggest), *args)
      end

      def route_args *args
        options = args.extract_options!
        resource = args.shift
        return args + [prefix] + ancestors.map(&:route_member) + [resource], options
      end

      def route_member suggest = nil
        plural? ? (suggest || member) : controller_name.singularize
      end

      def default_url_options *args
        Puffer::Base.default_url_options *args
      end

    end
  end
end
