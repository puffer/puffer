class SelectComponent < BaseComponent

  def form
    @options = case field.options[:select]
      when Symbol then
        parent_controller.view_context.send field.options[:select]
      when Proc then
        field.options[:select].bind(parent_controller.view_context).call
      else
        field.options[:select]
    end
    super
  end

end