class Admin::ProfilesController < Puffer::Base

  configure do
    group :users
  end

  index do
    field :user
    field :name
    field :surname
    field :birth_date
  end

  form do
    field :user
    field :name
    field :surname
    field :birth_date
    field :created_at
  end

end
