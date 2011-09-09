class Admin::CategoriesController < Puffer::TreeBase

  setup do
    group :posting
  end

  index do
    field :id
    field :hidden
    field :title
  end

  form do
    field :id
    field :hidden
    field :title
    field :parent_id, :type => :hidden
  end

end
