module Puffer
  module OrmAdapter
    module Mongoid

      def columns_hash
        klass.fields.inject({}) do |result, (name, object)|
          result.merge name => {:type => object.type.to_s.underscore.to_sym}
        end
      end

      def filter scope, fields, options = {}
        scope
      end

    end
  end
end

Mongoid::Document::OrmAdapter.send :include, Puffer::OrmAdapter::Mongoid