Rails.application.routes.draw do
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
    mount ActionCable.server => '/cable'

    devise_for :users

    resources :accounts, only: [:create]
    resources :exchanges, only: [:show, :create, :destroy] do
        get :autocomplete_card_name_ru, on: :collection
        get :autocomplete_card_name_en, on: :collection
    end
    resources :shifts, only: [:index, :create, :destroy]
    resources :lines, only: [:create, :destroy]
    resources :collections, only: [:create]
    resources :checks, only: [:index, :show, :create]
    resources :decks

    scope path: '/pages', controller: :pages do
        get 'index' => :index
        get 'decks' => :decks, as: 'expert_decks'
        get 'about' => :about, as: 'about'
        get 'collection' => :collection, as: 'collection'
        get 'unusable' => :unusable, as: 'unusable'
        get 'personal' => :personal, as: 'personal'
        post 'subscribe' => :subscribe, as: 'news_subscribe'
        post 'unsubscribe' => :unsubscribe, as: 'news_unsubscribe'
    end
    
    root 'pages#index'
end
