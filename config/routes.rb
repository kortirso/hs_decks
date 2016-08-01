Rails.application.routes.draw do
    devise_for :users
    resources :accounts, only: :index
    resources :decks
    root 'accounts#index'
end
