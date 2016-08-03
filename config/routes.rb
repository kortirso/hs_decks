Rails.application.routes.draw do
    devise_for :users
    resources :accounts, only: [:index, :create]
    resources :decks do
        get :autocomplete_card_name, on: :collection
    end
    root 'accounts#index'
end
