module Puffer
  module Inputs
    class Base

      attr_accessor :builder, :template, :field

      def initialize builder, template, field
        @builder = builder
        @field = field
        @template = template
      end

      def render
        template.html_safe
      end

      def template
        <<-INPUT
          #{label}
          #{error}
          #{input}
        INPUT
      end

      def label
        builder.label field
      end

      def input
        builder.text_field field, field.input_options
      end

      def error
        builder.object.errors[field.name.to_sym].first
      end

    end
  end
end
