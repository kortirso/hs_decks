class PagesController < ApplicationController
    before_action :get_access, only: [:collection, :unusable]

    def index

    end

    def decks
        @decks = Deck.filtered(filter_params).includes(:user).order(playerClass: :asc)
        @playerClasses = Player.all.map { |elem| elem.locale_name(@locale) }
    end

    def about

    end

    def collection
        @cards = Card.not_heroes.includes(:collection)
        @packs = current_user.positions.collect_ids
    end

    def unusable
        @unusable_cards = current_user.get_unusable_cards.sort_by { |elem| elem.cost }
    end

    private

    def filter_params
        params.permit(:playerClass, :power, :formats)
    end
end
