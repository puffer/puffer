class Admin::TagsController < Puffer::Base

  index do
    field :name
  end

  form do
    field :name
  end

end
