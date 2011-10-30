class ReferencesOneComponent < Puffer::Component::Base

  def form
    render
  end

  def choose
    @records = field.reflection.klass.to_adapter.filter(field.reflection.klass, field.children, :search => params[:puffer_search]).page(params[:page])
    render
  end

  def filter

  end

end