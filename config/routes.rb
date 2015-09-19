Rails.application.routes.draw do
  root 'home#index'

  get '/search', to: 'home#search', as: 'search'

  devise_for(:users,
    path: 'auth',
    skip: %i(registrations),
    controllers: {
      sessions: 'auth/sessions',
      omniauth_callbacks: 'auth/omniauth_callbacks'
    }
  )

  as :user do
    get 'auth/sign_up', to: 'auth/registrations#new', as: :new_user_registration
    post 'auth/sign_up', to: 'auth/registrations#create', as: :user_registration
  end

  resources :authors, only: %i(show index)
  resources :categories, only: :show

  resources :books, only: %i(show index) do
    resources :reviews, only: %i(new create index)
    resources :wishes, only: :create
  end

  resources :wishes, only: :destroy

  resources :users, only: :none do
    resources :wishes, only: :index
  end

  namespace :settings do
    resource :billing_address, :shipping_address, except: %i(new edit)

    resource :profile, except: %i(new edit create) do
      put 'update_info'
      put 'update_password'
    end

    # query and index hmmm
    resource :history, only: :none do
      get 'in_queue'
      get 'in_delivery'
      get 'delivered'
      get 'canceled'
    end
  end

  mount Shopper::Engine => '/cart', as: 'shopper'
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
end
