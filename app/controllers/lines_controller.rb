class LinesController < ApplicationController
    before_action :get_access
    before_action :check_user_role
    autocomplete :card, :name_ru
    autocomplete :card, :name_en

    def create

    end

    private

    def check_user_role
        render_404 unless current_user.deck_master?
    end

    def lines_params

    end
end
