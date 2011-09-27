class Admin::PostsController < Puffer::Base

  setup do
    group :posting
  end

  index do
    field 'user.email'
    field :status, :select => Post.statuses
    field :title
    field :body
  end

  form do
    field :user
    field :status, :select => Post.statuses
    field :title
    field :body
    field :filename, :type => :file
  end

end
