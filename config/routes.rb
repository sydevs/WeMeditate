Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users

  get 'switch_user' => 'switch_user#set_current_user'
  
  scope "(:locale)" do
    root to: "application#front"
    
    namespace :admin do
      root to: "application#dashboard"
      
      resources :users
      resources :articles
      resources :static_pages
      resources :tracks, only: [:index, :create, :update, :destroy]
      resources :meditations, only: [:index, :create, :update, :destroy]

      resources :cities do
        get :lookup, on: :collection, constraints: { format: 'json' }
      end

      resources :categories do
        put :sort, on: :collection
      end

      resources :mood_filters, only: [:index, :create, :update, :destroy] do
        put :sort, on: :collection
      end

      resources :instrument_filters, only: [:index, :create, :update, :destroy] do
        put :sort, on: :collection
      end

      resources :goal_filters, only: [:index, :create, :update, :destroy] do
        put :sort, on: :collection
      end

      resources :duration_filters, only: [:index, :create, :update, :destroy] do
        put :sort, on: :collection
      end
    end

    resources :categories, only: [:index, :show]
    resources :articles, only: [:show]
    resources :static_pages, only: [:show], page: '/'
    resources :meditations, only: [:show]
    resources :cities, only: [:show]
  end

end
