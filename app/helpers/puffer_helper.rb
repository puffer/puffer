module PufferHelper

  def puffer_namespaces_navigation
    Rails.application.routes.resources_tree.map(&:namespace).uniq.each do |namespace|
      yield namespace, send("#{namespace}_root_path"), namespace == puffer_namespace
    end
  end

  def puffer_groups_navigation namespace = puffer_namespace
    Rails.application.routes.resources_tree.roots.select {|node| node.controller.model && node.namespace == namespace}.uniq_by(&:group).each do |resource_node|
      path = send("#{resource_node.url_string}_path")
      current = resource.resource_node ? resource.root.resource_node.group == resource_node.group : false

      yield resource_node.group, path, current
    end
  end

  def puffer_resources_navigation namespace = puffer_namespace, group = configuration.group
    Rails.application.routes.resources_tree.roots.select {|node| node.controller.model && node.namespace == namespace && node.group == group}.each do |resource_node|
      title = resource_node.controller.model.model_name.human
      path = send("#{resource_node.url_string}_path")
      current = resource.resource_node ? resource.root.resource_node == resource_node : false

      yield title, path, current
    end
  end

  def render_head field
    field.human
  end

  def render_field field, record
    if field.options[:render]
      case field.options[:render]
      when Symbol then
        res = send(field.options[:render], record)
      when Proc then
        res = field.options[:render].bind(self).call(record)
      else ''
      end
    else
      res = record.call_chain(field.to_s)
    end
    unless field.native?
      url = edit_polymorphic_path [resource.namespace, record.call_chain(field.path)] rescue nil
      res = link_to res, url if url
    end
    res
  end

end
