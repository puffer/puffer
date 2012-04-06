class LocalizedComponent < BaseComponent

  def index
    render
  end

  def form
    @locales = field.options[:locales].presence || I18n.available_locales
    @values = @record.call_chain(field.to_s).presence || {}
    render
  end

end