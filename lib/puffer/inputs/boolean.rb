module Puffer
  module Inputs
    class Boolean < Puffer::Inputs::Base

      def template
        <<-INPUT
          #{input}
          #{label}
          #{error}
        INPUT
      end

      def input
        builder.check_box field, field.input_options
      end

    end
  end
end
