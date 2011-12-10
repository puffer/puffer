class Admin::ProfilesController < Puffer::GridBase

  setup do
    group :users
  end

  index do
    field 'user.email'
    field :name
    field :surname
    field :birth_date, :format => :long
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
