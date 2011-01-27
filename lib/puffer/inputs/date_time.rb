module Puffer
  module Inputs
    class DateTime < Puffer::Inputs::Base

      def input
        format = case field.type
          when :date                    then '%Y-%m-%d'
          when :time                    then '%H:%M:%S'
          when :datetime, :timestamp    then '%Y-%m-%d %H:%M:%S'
        end
        builder.text_field field, field.input_options.merge("data-calendar" => "{showButtons: true, listYears: true, format: '#{format}'}")
      end

    end
  end
end
