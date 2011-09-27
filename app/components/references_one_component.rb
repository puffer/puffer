class ReferencesOneComponent < Puffer::Component::Base

  def form
    render
  end

  def choose
    @records = field.reflection.klass.includes(field.children.includes).where(field.children.searches(params[:search])).page(params[:page])
    render
  end

  def filter

  end

end