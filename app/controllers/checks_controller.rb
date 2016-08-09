class ChecksController < ApplicationController
    before_action :get_access
    before_action :find_check, only: :show
    before_action :check_author, only: :show

    def show
        @deck = @check.deck
        @lines = @check.lines
    end

    def create
        Check.build(current_user.id, params)
    end

    private

    def find_check
        @check = Check.find_by(id: params[:id])
        render_404 if @check.nil? 
    end

    def check_author
        render_404 if current_user.id != @check.user_id
    end
end
