class DateTimeComponent < BaseComponent

  def index
    date = super
    date.to_s(field.options[:format].presence || :db) if date.present?
  end

  def form
    @format = time_format
    render
  end

  def filter
    @format = time_format
    render
  end

private

  def time_format
    @format ||= case field.type
      when :date                                then '%Y-%m-%d'
      when :time                                then '%H:%M:%S'
      when :datetime, :date_time, :timestamp    then '%Y-%m-%d %H:%M:%S'
    end
  end

end
