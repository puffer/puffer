# coding: utf-8

module Puffer
  module Helpers
    module PufferHelper

      def puffer_scopes_navigation
        Rails.application.routes.resources_tree.map(&:scope).uniq.each do |namespace|
          yield namespace, send("#{namespace}_root_path"), namespace == puffer_namespace if has_puffer_access?(namespace)
        end
      end

      def puffer_groups_navigation namespace = puffer_namespace
        Rails.application.routes.resources_tree.roots.select {|node| node.scope == namespace}.uniq_by(&:group).each do |resource_node|
          if resource_node.group
            path = send("#{resource_node.scope}_#{resource_node.url_segment}_path")
            current = resource.resource_node ? resource.root.resource_node.group == resource_node.group : false

            yield resource_node.group, path, current if has_puffer_access?(namespace)
          end
        end
      end

      def puffer_resources_navigation group = configuration.group, namespace = puffer_namespace
        Rails.application.routes.resources_tree.roots.select {|node| node.scope == namespace && node.group == group}.each do |resource_node|
          title = resource_node.controller.model.model_name.human
          path = send("#{resource_node.scope}_#{resource_node.url_segment}_path")
          current = resource.resource_node ? resource.root.resource_node == resource_node : false

          yield title, path, current if has_puffer_access?(namespace)
        end
      end

      def render_head field
        head = []
        if field.sort
          head.push link_to_unless(puffer_filters.puffer_order == field.sort, "▼", resource.collection_path(:page => params[:page], Puffer::Filters.model_name.param_key => puffer_filters.query.merge(:puffer_order => field.sort)))
          head.push link_to_unless(puffer_filters.puffer_order == [field.sort, :desc].join(' '), "▲", resource.collection_path(:page => params[:page], Puffer::Filters.model_name.param_key => puffer_filters.query.merge(:puffer_order => [field.sort, :desc].join(' '))))
        end
        head.push field.human
        head.join(' ').html_safe
      end

    end
  end
end
