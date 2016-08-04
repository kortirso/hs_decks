class DecksController < ApplicationController
    before_action :get_access
    before_action :check_user_role, except: :show
    before_action :find_deck, only: [:show, :edit, :update, :destroy]
    before_action :check_deck_author, only: [:edit, :update, :destroy]
    autocomplete :card, :name

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
            @deck = current_user.decks.create(decks_params)
            @deck.build_positions(params['deck']['positions_attributes'])
            redirect_to decks_path
        else
            redirect_to new_deck_path
        end
    end

    def edit
        @cards = Card.of_player_class(@deck.playerClass).or(Card.where(playerClass: nil)).order(name: :asc)
        (30 - @deck.positions.size).times { @deck.positions.build }
    end

    def update
        params['deck']['positions_attributes'] = Deck.remove_empty_params(params['deck']['positions_attributes'])
        if Deck.good_params?(params, @deck.playerClass)
            @deck.remove_positions(params['deck']['positions_attributes'])
            @deck.update(decks_params)
            redirect_to decks_path
        else
            redirect_to edit_deck_path(@deck)
        end
    end

    def destroy

    end

    private

    def building_positions
        @deck = current_user.decks.new
        30.times { @deck.positions.build }
    end

    def decks_params
        params.require(:deck).permit(:name, :playerClass, :link, :caption)
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
