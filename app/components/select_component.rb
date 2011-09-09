class SelectComponent < BaseComponent

  def form
    @options = case field.options[:select]
      when Symbol then
        parent_controller.send field.options[:select]
      when Proc then
        field.options[:select].bind(self).call
      else
        field.options[:select]
    end
    super
  end

end