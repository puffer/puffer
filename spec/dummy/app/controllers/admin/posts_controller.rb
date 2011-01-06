class Admin::PostsController < Puffer::Base

  configure do
    group :posting
  end

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
