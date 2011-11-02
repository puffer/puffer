class Admin::UsersController < Puffer::Base

  setup do
    group :users
    order 'email desc'
    show true
  end

  member do
    get :hello
  end

  collection do
    get :world
  end

  index do
    field :email
    field :password, :type => :password
    field :posts
  end

  form do
    field :email
    field :password, :type => :password
  end

end
