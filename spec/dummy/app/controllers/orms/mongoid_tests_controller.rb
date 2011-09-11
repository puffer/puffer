class Orms::MongoidTestsController < Puffer::Base

  setup do
    group :mongoid
  end

  index do
    field :string_field
    field :integer_field
    field :array_field
  end

  form do
    field :string_field
    field :integer_field
    field :array_field
  end

end