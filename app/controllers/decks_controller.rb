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
        @mulligans = @deck.mulligans.includes(:cards, :player)
    end

    def new
        @cards = Card.not_heroes.includes(:collection)
        @styles = Style.get_names(@locale)
    end

    def create
        if DeckConstructor.new(deck_params, current_user.id).build
            redirect_to decks_path
        else
            redirect_to new_deck_path
        end
    end

    def edit
        @cards = DeckGetAccessableCardsQuery.query(@deck.playerClass)
        @positions = @deck.positions.collect_ids
        @styles = Style.get_names(@locale)
    end

    def update
        if DeckConstructor.new(deck_params, current_user.id, @deck).refresh
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

    def find_deck
        @deck = Deck.friendly.find(params[:id])
        render_404 if @deck.nil? 
    end

    def check_deck_author
        render_404 if current_user.id != @deck.user_id
    end

    def deck_params
        params.slice(:deck, :cards).permit!
    end
end
