module Puffer
  module OrmAdapter
    module ActiveRecord

      def columns_hash
        klass.columns_hash.inject({}) do |result, (name, object)|
          result.merge name => {:type => object.type}
        end
      end

      def filter scope, fields, options = {}
        fields = fields.columns
        conditions, order = extract_conditions_and_order!(options)

        conditions_fields = fields.select {|f| conditions.keys.include?(f.field_name)}.to_fieldset
        search_fields = fields.select {|f| !conditions_fields.include?(f) && search_types.include?(f.column_type)}
        all_fields = conditions_fields + search_fields

        conditions = conditions.reduce({}) do |res, (name, value)|
          field = conditions_fields[name]
          res[field.query_column] = value if field
          res
        end

        order = order.map {|field, direction| "#{field} #{direction}"}.join(', ')

        scope.includes(includes(all_fields)).where(searches(search_fields, options[:search])).where(conditions).order(order)
      end

    private

      def search_types
        [:text, :string, :integer, :decimal, :float]
      end

      def includes fields
        fields.map {|f| f.path unless f.native?}.compact.to_includes
      end

      def searches fields, query
        [fields.map {|f| "#{f.query_column} like ?"}.compact.join(' or '), *(Array.wrap("%#{query}%") * fields.count)] if query.present?
      end

    end
  end
end

ActiveRecord::Base::OrmAdapter.send :include, Puffer::OrmAdapter::ActiveRecord