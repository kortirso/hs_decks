class DecksController < ApplicationController
    before_action :get_access, except: :show
    before_action :check_user_role, except: :show
    before_action :find_deck, only: [:show, :edit, :update, :destroy]
    before_action :check_deck_author, only: [:edit, :update, :destroy]

    def index
        @decks = current_user.decks
    end

    def show
        @packs = current_user.positions.collect_ids if current_user
        @positions = @deck.positions.collect_ids
    end

    def new
        @cards = Card.not_heroes.includes(:collection)
    end

    def create
        if Deck.build(deck_params, current_user.id)
            redirect_to decks_path
        else
            redirect_to new_deck_path
        end
    end

    def edit
        @cards = Card.for_all_classes.or(Card.not_heroes.of_player_class(@deck.playerClass)).includes(:collection)
        @positions = @deck.positions.collect_ids
    end

    def update
        if @deck.refresh(deck_params)
            redirect_to decks_path
        else
            redirect_to edit_deck_path(@deck)
        end
    end

    def destroy
        @deck.destroy
        redirect_to decks_path
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

    def deck_params
        params.permit!
    end
end
