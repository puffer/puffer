module PufferHelper

  def puffer_namespaces
    Rails.application.routes.puffer.keys.each do |prefix|
      yield prefix.to_s.humanize, send("#{prefix}_root_path"), prefix == namespace
    end
  end

  def puffer_navigation
    Rails.application.routes.puffer[namespace].values.map(&:first).each do |controller|
      title = controller.configuration.group.to_s.humanize
      path = polymorphic_url [namespace, controller.model]
      current = configuration.group && resource.root.controller.configuration.group == controller.configuration.group
      yield title, path, current
    end
  end

  def sidebar_puffer_navigation
    (Rails.application.routes.puffer[namespace][configuration.group] || []).each do |controller|
      title = controller.model.model_name.human
      path = polymorphic_url [namespace, controller.model]
      current = controller.controller_name == resource.root.controller_name
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
