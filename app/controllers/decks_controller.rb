class DecksController < ApplicationController
    before_action :get_access, except: :show
    before_action :check_user_role, except: :show
    before_action :find_deck, only: [:show, :edit, :update, :destroy, :change_format]
    before_action :check_deck_author, only: [:edit, :update, :destroy, :change_format]

    def index
        @decks = current_user.decks.order(playerClass: :asc, formats: :asc, power: :desc)
    end

    def show
        @packs = current_user.positions.collect_ids if current_user
        @positions = @deck.positions.collect_ids
        @mulligans = @deck.mulligans.includes(:cards, :player)
    end

    def new
        @cards = Card.includes(:collection)
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
        @cards = DeckGetAccessableCardsQuery.query(@deck)
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

    def change_format
        @deck.convert_to_standard
        redirect_to edit_deck_path(@deck)
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
