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
      resources :tracks

      resources :cities do
        get :lookup, on: :collection, constraints: { format: 'json' }
      end

      resources :categories do
        put :sort, on: :collection
      end

      resources :mood_filters do
        put :sort, on: :collection
      end

      resources :instrument_filters do
        put :sort, on: :collection
      end
    end

    resources :categories, only: [:index, :show]
    resources :articles, only: [:show]
    resources :static_pages, only: [:show], page: '/'
    resources :cities, only: [:show]
  end

end
