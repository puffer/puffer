Dummy::Application.routes.draw do

  devise_for :devise_users

  mount Puffer::Engine => '/'

end
