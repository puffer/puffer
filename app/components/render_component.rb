class RenderComponent < Puffer::Component::Base

  def action_missing name
    case field.options[:render]
    when Symbol then
      view_context.send(field.options[:render])
    when Proc then
      field.options[:render].bind(view_context).call
    else ''
    end
  end

end