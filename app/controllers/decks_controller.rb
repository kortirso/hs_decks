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
        @cards = Card.not_heroes.to_a
    end

    def create
        if Deck.build(params, current_user.id)
            redirect_to decks_path
        else
            redirect_to new_deck_path
        end
    end

    def edit

    end

    def update

    end

    def destroy

    end

    private

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
