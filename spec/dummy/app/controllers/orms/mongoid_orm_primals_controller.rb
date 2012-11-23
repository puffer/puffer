class Orms::MongoidOrmPrimalsController < Puffer::Base

  setup do
    group :mongoid_orm
    model_name 'mongoid_orm/primal'
  end

  index do
    field :string_field
    field :symbol_field
    field :select_field, :select => (1..5).map {|i| "option #{i}"}
    field :integer_field
    field :float_field
    field :decimal_field
    field :datetime_field
    field :time_field
    field :date_field
    field :boolean_field
    field :array_field
    field :hash_field
    field :set_field
    field :range_field
    field :time_zone
  end

  form do
    field :has_one_reference do
      field :name
    end

    field :has_many_references do
      field :name
    end

    field :has_one_nested do
      field :name
    end

    field :has_many_nesteds do
      field :name

      field :primal_reference do
        field :string_field
      end
    end

    field :embeds_one_nested do
      field :name
    end

    field :embeds_many_nesteds do
      field :name
    end

    field :string_field
    field :symbol_field
    field :select_field, :select => (1..5).map {|i| "option #{i}"}
    field :integer_field
    field :float_field
    field :decimal_field
    field :datetime_field
    field :time_field
    field :date_field
    field :boolean_field
    field :array_field
    field :hash_field
    field :set_field
    field :range_field
    field :localized_field_translations
    field :time_zone
  end

end