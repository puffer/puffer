Rails.application.routes.draw do

  namespace :admin do
    root :to => 'dashboard#index'
  end

end
