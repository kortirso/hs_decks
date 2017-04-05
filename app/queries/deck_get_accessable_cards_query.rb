class DeckGetAccessableCardsQuery
    def self.query(deck)
        Card.for_all_classes.or(Card.not_heroes.of_player_class(deck.playerClass)).
        return_for_format(deck.formats).
        includes(:collection)
    end
end