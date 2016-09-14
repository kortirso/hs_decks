class PagesController < ApplicationController
    before_action :get_access, only: :collection

    def index

    end

    def decks
        @decks = Deck.all.includes(:user).order(playerClass: :asc)
    end

    def about

    end

    def collection
        @cards = Card.not_heroes.includes(:collection)
        @packs = current_user.positions.collect_ids
    end
end
