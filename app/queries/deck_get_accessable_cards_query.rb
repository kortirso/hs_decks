class DeckGetAccessableCardsQuery
    def self.query(playerClass)
        Card.for_all_classes.
        or(Card.not_heroes.of_player_class(playerClass)).
        includes(:collection)
    end
end