class AccountsController < ApplicationController
    before_action :get_access

    def index
        @cards = Card.not_heroes.to_a
        @packs = current_user.packs.collect_ids.to_a
    end
end
