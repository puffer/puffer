module Puffer
  module Extensions

    module Object
      def call_chain chain
        swallow_nil{instance_eval(chain.to_s)}
      end
    end

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

    module Array
      def to_fieldset
        Puffer::FieldSet.new.concat self
      end

      def to_includes
        map do |field|
          sections = field.split('.').map(&:to_sym)
          hash = sections.pop
          sections.reverse_each do |section|
            hash = {section => hash}
          end
          hash
        end
      end
    end

  end
end

Object.send :include, Puffer::Extensions::Object
String.send :include, Puffer::Extensions::String
Symbol.send :include, Puffer::Extensions::Symbol
Array.send :include, Puffer::Extensions::Array

Kernel.class_eval do
  def swallow_nil
    yield
  rescue NoMethodError
    nil
  end
end
