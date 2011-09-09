class DateTimeComponent < BaseComponent

  def form
    @format = case field.type
      when :date                    then '%Y-%m-%d'
      when :time                    then '%H:%M:%S'
      when :datetime, :timestamp    then '%Y-%m-%d %H:%M:%S'
    end
    super
  end

end