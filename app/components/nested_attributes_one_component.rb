class NestedAttributesOneComponent < BaseComponent

  def form
    render
  end

  def permitted_params
    {"#{field.field_name}_attributes" => [:id, :_destroy] + field.children.map(&:component).map(&:permitted_params)}
  end

end
