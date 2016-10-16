class LinesController < ApplicationController
    before_action :get_access
    before_action :check_user_role

    def create
        Line.build(lines_params)
    end

    def destroy
        @line = Line.find_by(id: params[:id])
        @line.destroy
    end

    private

    def lines_params
        params.require(:lines).permit!
    end
end
