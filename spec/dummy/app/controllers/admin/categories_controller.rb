class Admin::CategoriesController < Puffer::Base

  configure do
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
