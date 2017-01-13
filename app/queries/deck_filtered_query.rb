class DeckFilteredQuery
    def initialize(decks = Deck.all)
        @decks = decks
    end

    def filtered(params)
        return @decks if params[:playerClass].nil?
        @decks = @decks.of_player_class(params[:playerClass]) unless params[:playerClass].empty?
        @decks = @decks.of_power(params[:power]) unless params[:power].empty?
        @decks = @decks.of_format(params[:formats]) if %w(standard wild).include?(params[:formats])
        @decks = @decks.of_style(params[:style]) unless params[:style].empty?
        @decks.includes(:user).order(playerClass: :asc)
    end
end