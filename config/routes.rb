Rails.application.routes.draw do

  namespace :admin do
    resource :session
  end
  
end