class SelectComponent < BaseComponent

  def form
    @options = select_options
    super
  end

  def filter
    @options = select_options
    p @options
    render
  end

private

  def select_options
    case field.options[:select]
      when Symbol then
        parent_controller.view_context.send field.options[:select]
      when Proc then
        field.options[:select].bind(parent_controller).call
      else
        field.options[:select]
    end
  end

end