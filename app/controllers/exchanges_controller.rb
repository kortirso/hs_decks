class ExchangesController < ApplicationController
    before_action :get_access
    before_action :check_user_role
    before_action :find_deck, only: :show
    before_action :check_deck_author, only: :show
    autocomplete :card, :name_ru
    autocomplete :card, :name_en

    def show
        @positions = @deck.positions.includes(:card, :exchanges).to_a.sort_by { |elem| [elem.card.cost, elem.card["name_#{@locale}"]] }
        @lines = @deck.lines
    end

    def create
        Exchange.build(exchange_params)
    end

    def destroy
        @exchange = Exchange.find_by(id: params[:id])
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

    def exchange_params
        params.require(:exchanges).permit!
    end
end
