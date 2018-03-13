class ChecksController < ApplicationController
  before_action :find_check, only: :show
  before_action :check_author, only: :show

  def index
    @checks = current_user.checks.includes(:deck).order(success: :desc)
    @player_classes = Player.is_playable.names_list(@locale.to_s)
    @styles = Style.names_list(@locale.to_s)
  end

  def show
    @deck = @check.deck
    @positions = @deck.positions.collect_ids
    @lines = @check.positions.collect_ids_with_caption
    @subs = @check.substitution.positions.collect_ids
  end

  def create
    Subs::SearchService.new(user: current_user, params: check_params).call
    redirect_to checks_path
  end

  private def find_check
    @check = Check.find_by(id: params[:id])
    render_404 if @check.nil?
  end

  private def check_author
    render_404 if current_user.id != @check.user_id
  end

  private def check_params
    params.permit(:playerClass, :formats, :power, :style)
  end
end
