class AccountsController < ApplicationController
    before_action :get_access

    def index
        @cards = Card.not_heroes.to_a
    end
end
