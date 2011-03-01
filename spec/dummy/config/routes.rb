Dummy::Application.routes.draw do

  match '/admin' => 'puffer/dashboard#index', :as => :admin

  namespace :puffer do
    root :to => 'dashboard#index'
    resource :session
  end

  namespace :admin do
    resources :users do
      resource :profile do
        resources :tags
      end
      resources :posts do
        resources :categories
        resources :tags
      end
    end
    resources :profiles do
      resources :tags
    end
    resources :posts do
      resource :user
      resources :categories
    end
    resources :categories do
      resources :posts
    end
    resources :news
  end

end
