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

        order = order.map { |name, dir| field = fields[name]; "#{query_order(field)} #{dir}" if field && field.column }.compact.join(', ')

        conditions_fields = fields.select {|f| f.column && conditions.keys.include?(f.field_name)}.to_fieldset
        search_fields = fields.select {|f| f.column && !conditions_fields.include?(f) && search_types.include?(f.column_type)}
        all_fields = conditions_fields + search_fields        

        scope = scope.includes(includes(all_fields)).includes(reflection_includes(fields)).where(searches(search_fields, options[:search])).order(order)

        conditions.each do |(name, value)|
          field = conditions_fields[name]
          scope = if value.is_a?(Hash)
            case
            when value[:from].blank? then scope.where(["#{query_column(field)} < ?", value[:till]])
            when value[:till].blank? then scope.where(["#{query_column(field)} > ?", value[:from]])
            else scope.where(name => Range.new(value[:from], value[:till]))
            end
          else
            scope.where(name => value)
          end if field
        end

        scope
      end

    private

      def search_types
        [:text, :string, :integer, :decimal, :float]
      end

      def includes fields
        fields.map {|f| f.path unless f.native?}.compact.to_includes
      end

      def reflection_includes fields
        fields.map {|f| f.field_name if f.reflection}.compact.to_includes
      end

      def searches fields, query
        [fields.map {|f| "#{query_column(f)} like ?"}.compact.join(' or '), *(Array.wrap("%#{query}%") * fields.count)] if query.present?
      end

      def query_column field
        "#{field.model.table_name}.#{field.name}" if field.column
      end

      def query_order field
        field.options[:order] || query_column(field)
      end

    end
  end
end

ActiveRecord::Base::OrmAdapter.send :include, Puffer::OrmAdapter::ActiveRecord