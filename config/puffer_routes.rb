Rails.application.routes.draw do

  namespace :puffer do
    root :to => 'dashboard#index'
    resource :session
  end
  
end