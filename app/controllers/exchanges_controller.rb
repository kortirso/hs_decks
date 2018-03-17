class ExchangesController < ApplicationController
  before_action :check_user_role
  before_action :find_deck, only: :show
  before_action :check_deck_author, only: :show
  before_action :find_exchange, only: :destroy

  def show
    @positions = DeckShowExchangesQuery.new(@deck).query
    @lines = @deck.lines
    @mulligans = @deck.mulligans.includes(:player, :positions)
    @cards = @deck.cards.collect { |elem| elem["name_#{@locale}"] }
  end

  def create
    ExchangesEngine.new(exchange_params).build
  end

  def destroy
    @exchange.destroy
  end

  private def find_deck
    @deck = Deck.find_by(id: params[:id])
    render_404 if @deck.nil?
  end

  private def check_deck_author
    render_404 if current_user.id != @deck.user_id
  end

  private def find_exchange
    @exchange = Exchange.find_by(id: params[:id])
    render_404 if @exchange.nil?
  end

  private def exchange_params
    params.require(:exchanges).permit!
  end
end
