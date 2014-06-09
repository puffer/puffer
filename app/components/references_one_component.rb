class ReferencesOneComponent < BaseComponent

  def index

  end

  def form
    render
  end

  def choose
    @records = field.reflection.klass.to_adapter
      .filter(field.reflection.klass, field.children, search: params[:search]).page(1).per(10)
    render
  end

  def permitted_params
    "#{field.field_name}_id"
  end

end
