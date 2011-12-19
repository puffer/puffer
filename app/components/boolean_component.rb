class BooleanComponent < BaseComponent

  def index
    render
  end

  def filter
    render
  end

  def change
    @record = resource.member
    @record.update_attributes field.to_s => !@record.call_chain(field.to_s)
    replace :index
  end

end