Rails.application.routes.draw do
    devise_for :users
    resources :accounts, only: [:index, :create]
    resources :decks
    root 'accounts#index'
end
