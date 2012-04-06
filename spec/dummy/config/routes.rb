Dummy::Application.routes.draw do

  devise_for :devise_users

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
  end

  namespace :orms do
    resources :active_record_orm_primals
    resources :mongoid_orm_primals
  end

end
