module PufferHelper

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
      res = h(record.call_chain(field.name))
    end
  end

end
