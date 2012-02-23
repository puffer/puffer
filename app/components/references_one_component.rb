class ReferencesOneComponent < BaseComponent

  def index

  end

  def form
    render
  end

  def choose
    @records = field.reflection.klass.to_adapter.filter(field.reflection.klass, field.children, :search => params[:puffer_search]).page(params[:page])
    render
  end

end
