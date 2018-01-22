Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "application#front"

  devise_for :users

  namespace :admin do
    root to: "application#dashboard"

    resources :users, except: [:show]
    resources :categories, except: [:show] do 
      collection do
        put 'sort'
      end
    end
    
    resources :articles, except: [:show]
  end

  resources :categories, only: [:index, :show]
  resources :articles, only: [:show]

end
