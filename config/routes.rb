Rails.application.routes.draw do
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
    mount ActionCable.server => '/cable'

    devise_for :users

    resources :accounts, only: [:create]
    resources :checks, only: [:index, :show, :create]

    resources :decks
    get 'decks/:id/exchanges' => 'decks#exchanges', as: 'deck_exchanges'

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
