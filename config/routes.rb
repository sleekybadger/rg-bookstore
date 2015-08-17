Rails.application.routes.draw do
  root 'home#index'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  devise_for(:users,
    path: 'auth',
    skip: %i(registrations),
    controllers: {
      sessions: 'auth/sessions'
    }
  )

  as :user do
    get 'auth/sign_up', to: 'auth/registrations#new', as: :new_user_registration
    post 'auth/sign_up', to: 'auth/registrations#create', as: :user_registration
  end

  resources :categories, only: %i(show)
  resources :books, only: %i(show index) do
    resources :reviews, only: %i(new create index)
    resource :order, only: [] do
      post 'add_item'
      delete 'remove_item'
    end
  end

  resource :cart, only: %i(show) do
    resources :checkouts, only: %i(show update)
  end

  namespace :settings do
    resource :billing_address, only: %i(create show update destroy)
    resource :shipping_address, only: %i(create show update destroy)
  end
end
