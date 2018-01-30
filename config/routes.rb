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
      resources :treatments, :meditations, :tracks,
                only: [:index, :create, :update, :destroy]

      resources :cities do
        get :lookup, on: :collection, constraints: { format: 'json' }
      end

      resources :categories, :mood_filters, :instrument_filters, :goal_filters, :duration_filters, 
                only: [:index, :create, :update, :destroy] do
        put :sort, on: :collection
      end
    end

    resources :articles, :cities, only: [:show]
    resources :static_pages, only: [:show], page: '/'
    resources :categories, only: [:index, :show]
    resources :meditations, only: [:show]
    resources :treatments, only: [:index, :show]
  end

end
