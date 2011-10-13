module Puffer
  module OrmAdapter
    module Mongoid

      def columns_hash
        klass.fields.inject({}) do |result, (name, object)|
          result.merge name => {:type => object.type.to_s.underscore.to_sym}
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
          res[field.name] = value if field
          res
        end

        scope = scope.any_of(searches(search_fields, options[:search])) if options[:search].present?
        scope.where(conditions).order(order)
      end

    private

      def search_types
        [:string, :integer, :big_decimal, :float, :"bson/object_id", :symbol]
      end

      def searches fields, query
        regexp = /#{Regexp.escape(query)}/
        fields.map {|field| {field.name => regexp}}
      end

    end
  end
end

Mongoid::Document::OrmAdapter.send :include, Puffer::OrmAdapter::Mongoid