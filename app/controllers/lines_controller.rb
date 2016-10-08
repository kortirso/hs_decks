class LinesController < ApplicationController
    before_action :get_access
    before_action :check_user_role

    def create
        Line.build(lines_params)
    end

    private

    def check_user_role
        render_404 unless current_user.deck_master?
    end

    def lines_params
        params.require(:lines).permit!
    end
end
