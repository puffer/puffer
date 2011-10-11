class Orms::ActiveRecordOrmPrimalsController < Puffer::Base

  setup do
    group :active_record
    model_name 'active_record_orm/primal'
  end

  index do
    field :string_field
    field :text_field
    field :select_field, :select => 5.times {|i| "option #{i}"}
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
    field :string_field
    field :text_field
    field :select_field, :select => 5.times {|i| "option #{i}"}
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