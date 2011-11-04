class Admin::NewsController < Puffer::Base

  setup do
    group :news
  end

  index do
    field :title
    field :body
    field :renderable, :render => lambda { @record.title }
  end

  form do
    field :title
    field :body
  end

end
