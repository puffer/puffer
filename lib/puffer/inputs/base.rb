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
        html.html_safe
      end

      def html
        <<-INPUT
          <div class="label">
            #{label}
            <div class="field_error">
              #{error}
            </div>
          </div>
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

      def method_missing method, *args, &block
        template.send method, *args, &block if template.respond_to? method
      end

    end
  end
end
