class ExchangesController < ApplicationController
    before_action :get_access
    before_action :check_user_role
    before_action :find_deck, only: :show
    before_action :check_deck_author, only: :show
    before_action :find_exchange, only: :destroy
    autocomplete :card, :name_ru
    autocomplete :card, :name_en

    def show
        @positions = @deck.positions.includes(:card, :exchanges).to_a.sort_by { |elem| [elem.card.cost, elem.card["name_#{@locale}"]] }
        @lines = @deck.lines
    end

    def create
        ExchangesEngine.new(exchange_params).build
    end

    def destroy
        @exchange.destroy
    end

    private

    def find_deck
        @deck = Deck.find_by(id: params[:id])
        render_404 if @deck.nil?
    end

    def check_deck_author
        render_404 if current_user.id != @deck.user_id
    end

    def find_exchange
        @exchange = Exchange.find_by(id: params[:id])
        render_404 if @exchange.nil?
    end

    def exchange_params
        params.require(:exchanges).permit!
    end
end
