class Admin::UsersController < Puffer::Base

  setup do
    group :users
  end

  index do
    field :email
    field :password, :type => :password
  end

  form do
    field :email
    field :password, :type => :password
  end

end
