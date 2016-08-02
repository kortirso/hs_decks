class AccountsController < ApplicationController
    before_action :get_access

    def index
        @cards = Card.not_heroes.to_a
        @packs = current_user.packs.collect_ids
    end

    def create
        Pack.build(current_user.id, params, current_user.packs.collect_ids)
    end
end
