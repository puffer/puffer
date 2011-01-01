class Admin::ProfilesController < Puffer::Base

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
  end

end
