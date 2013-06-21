class BaseComponent < Puffer::Component::Base

  def index
    @record.call_chain(field.to_s)
  end

  def form
    render
  end

  def filter
  end

  def permitted_params
    field.field_name
  end

end
