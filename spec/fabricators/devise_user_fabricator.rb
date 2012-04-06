Fabricator :devise_user do
  email {Forgery::Internet.email_address}
  password '123456'
  password_confirmation '123456'
end