class AccountsController < ApplicationController
    before_action :get_access

    def index
        @cards = Card.not_heroes.to_a
        @packs = current_user.packs.collect_ids
        @checks = current_user.checks.includes(:deck).order(success: :asc)
        @decks = Deck.all.includes(:user).order(playerClass: :asc)
    end

    def create
        Pack.build(current_user.id, params, current_user.packs.collect_ids)
    end
end
