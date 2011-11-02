class DateTimeComponent < BaseComponent

  def index
    date = super
    date.to_s(field.options[:format].presence || :db) if date.present?
  end

  def form
    @format = case field.type
      when :date                    then '%Y-%m-%d'
      when :time                    then '%H:%M:%S'
      when :datetime, :timestamp    then '%Y-%m-%d %H:%M:%S'
    end
    super
  end

end