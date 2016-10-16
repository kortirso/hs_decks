class ShiftsController < ApplicationController
    before_action :get_access
    before_action :check_user_role

    def index
        @shifted_cards = Card.with_shifts.sort_by { |card| card.cost }
    end

    def create

    end

    def destroy

    end

    private

    def shift_params
        params.require(:shifts).permit!
    end
end
