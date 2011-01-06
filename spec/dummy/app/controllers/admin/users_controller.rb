class Admin::UsersController < Puffer::Base

  configure do
    group :users
  end

  index do
    field :email
    field :password
  end

  form do
    field :email
    field :password
  end

end
