Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users

  scope "(:locale)" do
    root to: "application#front"
    
    namespace :admin do
      root to: "application#dashboard"

      resources :categories, except: [:show] do 
        collection do
          put 'sort'
        end
      end
      
      resources :users, except: [:show]
      resources :articles, except: [:show]
      resources :tracks, except: [:show]
    end

    resources :categories, only: [:index, :show]
    resources :articles, only: [:show]
  end

end
