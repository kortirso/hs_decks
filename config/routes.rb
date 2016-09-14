Rails.application.routes.draw do
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
    mount ActionCable.server => '/cable'
    devise_for :users
    resources :accounts, only: [:create]
    resources :checks, only: [:index, :show, :create]
    resources :decks
    scope path: '/pages', controller: :pages do
        get 'index' => :index
        get 'decks' => :decks, as: 'expert_decks'
        get 'about' => :about, as: 'about'
        get 'collection' => :collection, as: 'collection'
    end
    root 'pages#index'
end
