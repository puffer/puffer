class Admin::UsersController < Puffer::Base
  before_filter :i_didnt_forget_to_protect_this

  index do
    field :email
    field :password
  end

  form do
    field :email
    field :password
  end

end
