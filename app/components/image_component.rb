class ImageComponent < BaseComponent

  def form
    @options = image_options
    super
  end

  def filter
    @options = image_options
    render
  end

  private

  def image_options
    unless field.options[:image].present? and field.options[:image][:style].present?
      field.options.merge!({:image => {:style => :thumb}})
    end
  end

end
