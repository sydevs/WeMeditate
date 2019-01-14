Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users

  get 'switch_user' => 'switch_user#set_current_user'
  get :maintenance, to: 'application#maintenance'
  get '/', to: redirect('/en')

  scope ':locale' do
    localized do
      root to: 'application#front'

      namespace :admin do
        root to: 'application#dashboard'

        resources :articles, :static_pages, :cities, only: [] do
          patch :review, on: :member
        end

        resources :cities, only: [] do
          get :lookup, on: :collection, constraints: { format: 'json' }
        end

        resources :treatments, :categories, :mood_filters, :instrument_filters, :goal_filters, :duration_filters, :sections, only: [] do
          put :sort, on: :collection
        end

        resources :articles, :static_pages, :cities, :subtle_system_nodes do
          post :upload_media, on: :member, path: :media, as: :upload_to
          delete :destroy_media, on: :member, path: 'media/:qquuid', as: :destroy_media_for
          resources :sections, only: [:new, :create]
        end

        resources :users, :artists, :treatments, :meditations, :tracks, :sections,
                  :categories, :mood_filters, :instrument_filters, :goal_filters, :duration_filters,
                  only: [:index, :new, :edit, :create, :update, :destroy]

        resources :sections, only: [:edit, :update, :destroy]
      end

      post :contact, to: 'application#contact'
      post :subscribe, to: 'application#subscribe'

      resources :articles, only: [:index, :show], path: 'inspiration' do
        get '/category/:category_id', on: :collection, action: :index
      end

      resources :cities, only: [:show, :index] do
        post :register, on: :member
        get :local, on: :collection
      end

      get '/countries/:country_code', controller: :cities, action: :country, as: :country

      resources :meditations, only: [:index, :show] do
        get :random, on: :collection
        post :find, on: :collection
        post :record_view, on: :member
      end

      #resources :categories, only: [:show] # TODO: Remove this
      resources :treatments, only: [:index, :show], path: 'techniques'
      resources :tracks, only: [:index], path: 'music'
      resources :static_pages, only: [:show], path: 'page'
      resources :subtle_system_nodes, only: [:index, :show], path: 'subtle_system'
    end
  end

end
