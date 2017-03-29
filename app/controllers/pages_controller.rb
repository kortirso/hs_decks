class PagesController < ApplicationController
    include SubscribeController
    before_action :get_access, except: [:index, :decks, :about]

    def index
        @news = News.order(id: :desc).limit(4)
        @top_decks = Deck.order(power: :desc).limit(4)
    end

    def decks
        @decks = DeckFilteredQuery.new.filtered(filter_params)
        @playerClasses = PlayerGetPlayableNamesQuery.query
        @styles = Style.get_names(@locale)
    end

    def about
        
    end

    def collection
        @cards = Card.not_heroes.includes(:collection)
        @packs = current_user.positions.collect_ids
    end

    def unusable
        @unusable_cards = current_user.get_unusable_cards
    end

    def personal
        @user = current_user
    end

    private

    def filter_params
        params.permit(:playerClass, :power, :formats, :style)
    end
end
