Rails.application.routes.draw do
  root 'home#index'
  get '/search', to: 'home#search', as: 'search'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

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

  resources :categories, only: %i(show)

  resources :books, only: %i(show index) do
    resources :reviews, only: %i(new create index)

    resource :order, only: :none do
      post 'add_item'
      delete 'remove_item'
    end

    resource :wishes, only: %i(create destroy)
  end

  resources :users, only: :none do
    resources :wishes, only: %i(index)
  end

  resource :cart, only: %i(show) do
    resources :checkout, only: %i(show update)

    get 'complete'
  end

  namespace :settings do
    resource :billing_address, :shipping_address, except: %i(new edit)

    resource :profile, except: %i(new edit create) do
      put 'update_info'
      put 'update_password'
    end

    resource :history, only: :none do
      get 'in_queue'
      get 'in_delivery'
      get 'delivered'
      get 'canceled'
    end
  end
end
