Rails.application.routes.draw do
    apipie
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

    devise_for :users

    resources :accounts, only: %i[create]
    resources :exchanges, only: %i[show create destroy] do
        get :autocomplete_card_name_ru, on: :collection
        get :autocomplete_card_name_en, on: :collection
    end
    resources :shifts, only: %i[index create destroy] do
        post :create_shift, on: :collection
    end
    resources :lines, only: %i[create destroy]
    resources :mulligans, only: %i[create destroy]
    resources :collections, only: %i[create]
    resources :checks, only: %i[index show create]
    resources :decks do
        post :change_format, on: :collection
    end

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
            resources :cards, only: :index
            resources :decks, only: %i[index show]
            resources :about, only: :index
        end
    end

    root 'pages#index'
    match '*path', to: 'application#catch_404', via: :all
end
