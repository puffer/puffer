module Puffer
  module OrmAdapter
    module ActiveRecord

      def columns_hash
        klass.columns_hash.inject({}) do |result, (name, object)|
          result.merge name => {:type => object.type}
        end
      end

    end
  end
end

ActiveRecord::Base::OrmAdapter.send :include, Puffer::OrmAdapter::ActiveRecord