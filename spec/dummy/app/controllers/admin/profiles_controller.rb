class Admin::ProfilesController < Puffer::Base

  setup do
    group :users
  end

  index do
    field 'user.email'
    field :name
    field :surname
    field :birth_date
  end

  form do
    field :user do
      field :email
      field :password
    end
    field :name
    field :surname
    field :birth_date
    field :created_at
  end

end
