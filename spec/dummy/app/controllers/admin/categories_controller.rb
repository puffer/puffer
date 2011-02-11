class Admin::CategoriesController < Puffer::Base

  setup do
    group :posting
  end

  index do
    field :id
    field :title
  end

  form do
    field :id
    field :title
  end

end
