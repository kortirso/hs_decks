class AccountsController < ApplicationController
    before_action :get_access

    def index
        @cards = Card.not_heroes.includes(:collection)
        @packs = current_user.positions.collect_ids
        @checks = current_user.checks.includes(:deck).order(success: :desc)
        @decks = Deck.all.includes(:user).order(playerClass: :asc)
    end

    def create
        current_user.build_collection(params)
        head :ok
    end
end
