class DecksController < ApplicationController
    before_action :get_access
    before_action :check_user_role, except: :show
    before_action :find_deck, only: [:show, :edit, :update, :destroy]
    before_action :check_deck_author, only: [:edit, :update, :destroy]

    def index
        @decks = current_user.decks
    end

    def show
        
    end

    def new
        building_positions
    end

    def create
        params['deck']['positions_attributes'] = Deck.remove_empty_params(params['deck']['positions_attributes'])
        if Deck.good_params?(params)
            Deck.create(decks_params.merge(user: current_user))
            render :index
        else
            building_positions
            render :new
        end
    end

    def edit

    end

    def update

    end

    def destroy

    end

    private

    def building_positions
        @cards = Card.not_heroes.order(name: :asc)
        @deck = current_user.decks.new
        30.times { @deck.positions.build }
    end

    def decks_params
        params.require(:deck).permit(:name, :playerClass, positions_attributes: [:card_id, :amount, :id, :_destroy])
    end

    def check_user_role
        render_404 unless current_user.deck_master?
    end

    def find_deck
        @deck = Deck.find_by(id: params[:id])
        render_404 if @deck.nil? 
    end

    def check_deck_author
        render_404 if current_user.id != @deck.user_id
    end
end
