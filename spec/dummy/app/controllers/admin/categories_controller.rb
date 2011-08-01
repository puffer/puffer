class Admin::CategoriesController < Puffer::TreeBase

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
    field :parent do
      field :title
    end
  end

end
