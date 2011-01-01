class Admin::CategoriesController < Puffer::Base

  index do
    field :id
    field :title
  end

  form do
    field :id
    field :title
  end

end
