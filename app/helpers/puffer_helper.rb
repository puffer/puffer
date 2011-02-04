module PufferHelper

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
      url = edit_polymorphic_path [resource.prefix, record.call_chain(field.path)] rescue nil
      res = link_to res, url if url
    end
    res
  end

end
