module PufferHelper

  def puffer_navigation
    Rails.application.routes.puffer[namespace].values.map(&:first).each do |controller|
      title = controller.configuration.group.to_s.humanize
      path = send("#{namespace}_#{controller.controller_name}_path")
      current = configuration.group && resource.root.controller.configuration.group == controller.configuration.group
      yield title, path, current
    end
  end

  def sidebar_puffer_navigation
    (Rails.application.routes.puffer[namespace][configuration.group] || []).each do |controller|
      title = controller.model.model_name.human
      path = send("#{namespace}_#{controller.controller_name}_path")
      current = controller.controller_name == resource.root.controller_name
      yield title, path, current
    end
  end

  def puffer_stylesheets
    stylesheet_link_tag *Puffer.stylesheets.map {|path| "/puffer/stylesheets/#{path}"}.uniq.compact
  end

  def puffer_javascripts
    javascript_include_tag *Puffer.javascripts.map {|path| "/puffer/javascripts/#{path}"}.uniq.compact
  end

  def render_head field
    field.label
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
      res = record.call_chain(field.field)
    end
    unless field.native?
      url = edit_polymorphic_path [resource.namespace, record.call_chain(field.path)] rescue nil
      res = link_to res, url if url
    end
    res
  end

end
