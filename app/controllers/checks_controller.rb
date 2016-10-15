class ChecksController < ApplicationController
    before_action :get_access
    before_action :find_check, only: :show
    before_action :check_author, only: :show

    def index
        @checks = current_user.checks.includes(:deck).order(success: :desc)
        @player_classes = Player.names(@locale)
        @styles = Style.get_names(@locale)
    end

    def show
        @deck = @check.deck
        @positions = @deck.positions.collect_ids
        @lines = @check.positions.collect_ids_with_caption
        @subs = @check.substitution.positions.collect_ids
    end

    def create
        Check.build(current_user.id, check_params, @locale)
        head :ok
    end

    private

    def find_check
        @check = Check.find_by(id: params[:id])
        render_404 if @check.nil? 
    end

    def check_author
        render_404 if current_user.id != @check.user_id
    end

    def check_params
        params.permit(:success, :dust, :playerClass, :formats, :power, :style)
    end
end
