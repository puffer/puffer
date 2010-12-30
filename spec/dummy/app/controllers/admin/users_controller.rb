class Admin::UsersController < Puffer::Base

  index do
    field :email
    field :password
  end

  form do
    field :email
    field :password
  end

end
