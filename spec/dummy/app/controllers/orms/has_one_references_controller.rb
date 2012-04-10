class Orms::HasOneReferencesController < Puffer::Base

  setup do
    group :mongoid_orm
    model_name "mongoid_orm/has_one_reference"
  end

  index do
    field :name
  end

  form do
    field :name
    field :primal_nested
    field :primal_reference
  end

end
