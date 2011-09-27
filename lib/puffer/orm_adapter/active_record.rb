module Puffer
  module OrmAdapter
    module ActiveRecord

      def columns_hash
        klass.columns_hash.inject({}) do |result, (name, object)|
          result.merge name => {:type => object.type}
        end
      end

      def filter scope, fields, options = {}
        conditions, order = extract_conditions_and_order!(options)
        scope.includes(fields.includes).where(fields.searches(options[:search])).where(conditions).order(order)
      end

    end
  end
end

ActiveRecord::Base::OrmAdapter.send :include, Puffer::OrmAdapter::ActiveRecord