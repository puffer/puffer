Dummy::Application.routes.draw do

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
    resources :tagged_posts do
      resource :user
      resources :categories
      resources :tags
    end
    resources :categories do
      resources :posts
    end
    resources :news
    resources :puffer_users
  end

  namespace :orms do
    resources :activerecord_orms
    resources :mongoid_orms
  end

end
