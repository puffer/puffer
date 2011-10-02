class Orms::MongoidOrmPrimalsController < Puffer::Base

  setup do
    group :mongoid
    model_name 'mongoid_orm/primal'
  end

  index do
    field :string_field
    field :symbol_field
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
  end

  form do
    field :string_field
    field :symbol_field
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
  end

end