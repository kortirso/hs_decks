Rails.application.routes.draw do
    apipie
    use_doorkeeper
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
    mount ActionCable.server => '/cable'

    devise_for :users

    resources :accounts, only: [:create]
    resources :exchanges, only: [:show, :create, :destroy] do
        get :autocomplete_card_name_ru, on: :collection
        get :autocomplete_card_name_en, on: :collection
    end
    resources :shifts, only: [:index, :create, :destroy] do
        post :create_shift, on: :collection
    end
    resources :lines, only: [:create, :destroy]
    resources :mulligans, only: [:create, :destroy]
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

    namespace :api do
        namespace :v1 do
            scope path: '/public', controller: :public do
                get 'all' => :all
                post 'all_post' => :all_post
            end
            resources :decks, only: [:index, :show]
            resources :about, only: :index
        end
    end
    
    root 'pages#index'
    match "*path", to: "application#catch_404", via: :all
end
