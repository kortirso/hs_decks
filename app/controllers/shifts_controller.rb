class ShiftsController < ApplicationController
    before_action :get_access
    before_action :check_user_role
    before_action :find_check, only: :destroy

    def index
        @shifted_cards = Card.with_shifts.sort_by { |card| card.cost }
    end

    def create
        ShiftsUpdatingEngine.new(shift_params).build
    end

    def create_shift
        ShiftsCreationEngine.new(shift_params).build
    end

    def destroy
        @shift.destroy
    end

    private

    def find_check
        @shift = Shift.find_by(id: params[:id])
        render_404 if @shift.nil?
    end

    def shift_params
        params.require(:shifts).permit!
    end
end
