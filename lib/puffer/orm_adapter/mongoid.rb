module Puffer
  module OrmAdapter
    module Mongoid

      def columns_hash
        klass.fields.inject({}) do |result, (name, object)|
          result.merge name => {:type => object.type.to_s.underscore.to_sym}
        end
      end

      def reflection name
        reflection = klass.reflect_on_association(name.to_sym)
        Reflection.new(
          :klass => reflection.klass,
          :macro => reflection.macro,
          :through? => false,
          :accessor => accessor_for(reflection),
          :primary_key => :_id
        ) if reflection
      end

      def filter scope, fields, options = {}
        conditions, order = extract_conditions_and_order!(options)

        order = order.map { |o| f = fields[o.first]; [query_order(f), o.last] if f && f.column }.compact

        conditions_fields = fields.select {|f| f.column && conditions.keys.include?(f.field_name)}.to_fieldset
        search_fields = fields.select {|f| f.column && !conditions_fields.include?(f) && search_types.include?(f.column_type)}
        all_fields = conditions_fields + search_fields

        scope = scope.any_of(searches(search_fields, options[:search])) if options[:search].present?
        scope = scope.order_by(order)

        conditions.each do |name, value|
          field = conditions_fields[name]
          scope = if value.is_a?(Puffer::Filters::Diapason)
            case
            when value.from.blank? then scope.where(name.to_sym.lt => value.till)
            when value.till.blank? then scope.where(name.to_sym.gt => value.from)
            else scope.where(name => Range.new(value.from, value.till))
            end
          else
            scope.where(name => value)
          end if field
        end

        scope
      end

    private

      def search_types
        [:string, :integer, :big_decimal, :float, :"bson/object_id", :symbol]
      end

      def searches fields, query
        regexp = /#{Regexp.escape(query)}/i
        fields.map {|field| {field.to_s => regexp}}
      end

      def query_order field
        field.options[:order] || field.name
      end

      def accessor_for reflection
        case reflection.macro
        when :referenced_in, :belongs_to then
          reflection.foreign_key
        when :references_one, :has_one then
          "#{reflection.name}_id"
        when :references_many, :references_and_referenced_in_many, :has_many, :has_and_belong_to_many then
          "#{reflection.name.to_s.singularize}_ids"
        end
      end

    end
  end
end

Mongoid::Document::OrmAdapter.send :include, Puffer::OrmAdapter::Mongoid