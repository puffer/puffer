class LocalizedComponent < BaseComponent

  def index
    render
  end

  def form
    @locales = I18n.available_locales
    @values = @record.call_chain(field.to_s).presence || {}
    render
  end

end