class BooleanComponent < BaseComponent

  def index
    render
  end

  def change
    opts[:record] = resource.member
    opts[:record].update_attributes field.to_s => !opts[:record].call_chain(field.to_s)
    replace :index
  end

end