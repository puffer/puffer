class CarrierwaveComponent < FileComponent

  helper_method :thumbnail_name

  def index
    render
  end


private

  def thumbnail_name
    field.options[:thumbnail].presence || :puffer
  end

end
