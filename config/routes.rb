Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users

  get '404', to: 'application#error'
  get '422', to: 'application#error'
  get '500', to: 'application#error'
  get 'switch_user' => 'switch_user#set_current_user'
  get :maintenance, to: 'application#maintenance'
  get 'robots.txt', to: 'application#robots', defaults: { format: :txt }
  get '/', to: redirect('/en')

  scope ':locale' do
    localized do
      root to: 'application#home'

      namespace :admin do
        root to: 'application#dashboard'
        get :vimeo_data, to: 'application#vimeo_data', constraints: { format: :json }

        resources :treatments, :categories, :mood_filters, :instrument_filters, :goal_filters, :duration_filters, only: [] do
          put :sort, on: :collection
        end

        resources :articles, :static_pages, :subtle_system_nodes, except: %i[destroy] do
          get :write, on: :member
          get :review, on: :member
          get :preview, on: :member
          resources :media_files, only: %i[index create]
        end

        resources :articles, :subtle_system_nodes, only: %i[destroy]

        resources :users, :artists, :treatments, :meditations, :tracks,
                  :categories, :mood_filters, :instrument_filters, :goal_filters, :duration_filters,
                  only: %i[index new edit create update destroy]
      end

      post :contact, to: 'application#contact'
      post :subscribe, to: 'application#subscribe'
      get :map, to: 'application#map'

      resources :articles, only: %i[show] do
        get '/category/:category_id', on: :collection, action: :index
      end

      resources :meditations, only: %i[index show] do
        get :archive, on: :collection
        get :random, on: :collection
        post :find, on: :collection
        post :record_view, on: :member
      end

      resources :categories, only: %i[index show], path: 'inspiration'
      resources :treatments, only: %i[index show], path: 'techniques'
      resources :tracks, only: %i[index], path: 'music'
      resources :static_pages, only: %i[show], path: 'page'
      resources :subtle_system_nodes, only: %i[index show], path: 'subtle_system'
    end
  end
end
