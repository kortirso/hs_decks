Rails.application.routes.draw do
    devise_for :users
    resources :accounts, only: [:index, :create]
    resources :checks, only: [:show, :create]
    resources :decks
    root 'accounts#index'
end
