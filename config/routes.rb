Rails.application.routes.draw do
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
    mount ActionCable.server => '/cable'
    devise_for :users
    resources :accounts, only: [:index, :create]
    resources :checks, only: [:show, :create]
    resources :decks
    root 'accounts#index'
end
