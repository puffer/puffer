module Puffer
  module Helpers
    module ComponentHelper

      def component_wrap name = :span, options = {}, &block
        content_tag name, options.merge(:id => component_id), &block
      end

      def paginate(scope, options = {}, &block)
        paginator = Kaminari::Helpers::Paginator.new parent_controller.view_context, options.reverse_merge(:current_page => scope.current_page, :num_pages => scope.num_pages, :per_page => scope.limit_value, :param_name => Kaminari.config.param_name, :remote => false)
        paginator.to_s
      end

      def component_fields_for record, &block
        if opts[:builder]
          capture opts[:builder], &block
        else
          fields_for record, &block
        end
      end

    end
  end
end