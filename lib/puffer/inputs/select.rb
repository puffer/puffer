module Puffer
  module Inputs
    class Select < Puffer::Inputs::Base

      def input
        options = case field.options[:select]
          when Symbol then
            send field.options[:select]
          when Proc then
            field.options[:select].bind(temptate).call
          else
            field.options[:select]
        end
        builder.select field, options, {:include_blank => field.options[:include_blank]}, field.input_options
      end

    end
  end
end
