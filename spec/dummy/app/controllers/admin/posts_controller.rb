class Admin::PostsController < Puffer::Base

  setup do
    group :posting
  end

  index do
    field 'user.email'
    field :status
    field :title
    field :body
  end

  form do
    field :user do
      field :email
    end
    field :status, :select => Post.statuses
    field :title
    field :body
    field :filename, :type => :file
  end

end
