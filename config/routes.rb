Rails.application.routes.draw do

  namespace :admin do
  	root :to => 'dashboard#index'
    resource :session
  end
  
end