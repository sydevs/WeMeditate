Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "application#front"

  devise_for :users

  namespace :admin do
    root to: "application#dashboard"

    resources :users, except: [:show]
    resources :categories, except: [:show]
    resources :articles, except: [:show] do 
      resources :sections, only: [:create, :update, :destroy]
    end
  end

  resources :categories, only: [:index, :show]
  resources :articles, only: [:show]

end
