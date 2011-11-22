class Orms::ActiveRecordOrmPrimalsController < Puffer::Base

  setup do
    group :active_record
    model_name 'active_record_orm/primal'
  end

  index do
    field :string_field
    field :text_field
    field :select_field, :select => (1..5).map {|i| "option #{i}"}
    field :integer_field
    field :float_field
    field :decimal_field
    field :datetime_field
    field :timestamp_field
    field :time_field
    field :date_field
    field :boolean_field
  end

  form do
    field :has_one_reference do
      field :name
    end

    field :has_many_references do
      field :name
    end

    field :string_field
    field :text_field
    field :select_field, :select => (1..5).map {|i| "option #{i}"}
    field :integer_field
    field :float_field
    field :decimal_field
    field :datetime_field
    field :timestamp_field
    field :time_field
    field :date_field
    field :boolean_field
  end

end