class RenderComponent < Puffer::Component::Base

  def action_missing name
    field.options[:render].bind(self).call
  end

end