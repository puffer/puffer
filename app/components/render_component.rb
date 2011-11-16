class RenderComponent < Puffer::Component::Base

  def action_missing name
    case field.options[:render]
    when Symbol then
      send(field.options[:render])
    when Proc then
      field.options[:render].bind(self).call
    else ''
    end
  end

end