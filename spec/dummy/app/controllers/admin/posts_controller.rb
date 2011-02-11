class Admin::PostsController < Puffer::Base

  setup do
    group :posting
  end

  index do
    field :id
    field 'user.email'
    field :title
    field :body
  end

  form do
    field :id
    field :user, :columns => [:email]
    field :title
    field :body
  end

end
