class Admin::PostsController < Puffer::Base

  index do
    field :user
    field :title
    field :body
  end

  form do
    field :user
    field :title
    field :body
  end

end
