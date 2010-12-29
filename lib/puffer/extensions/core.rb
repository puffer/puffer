module Puffer
  module Extensions

    module String
      def singular?
        self.singularize == self
      end

      def plural?
        self.pluralize == self
      end
    end

    module Symbol
      def singular?
        to_s.singular?
      end

      def plural?
        to_s.plural?
      end
    end

  end
end

String.send :include, Puffer::Extensions::String
Symbol.send :include, Puffer::Extensions::Symbol

Kernel.class_eval do
  def swallow_nil
    yield
  rescue NoMethodError
    nil
  end
end
