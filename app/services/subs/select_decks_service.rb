module Subs
    class SelectDecksService
        def self.call(args)
            decks = Deck.includes(:positions)
            decks = decks.of_player_class(Player.return_en(args[:playerClass])) unless args[:playerClass].empty?
            decks = decks.of_format('standard') if args[:formats] == 'standard'
            decks = decks.of_power(args[:power]) if args[:power].to_i.between?(1, 10)
            decks = decks.of_style(args[:style]) unless args[:style].empty?
            decks
        end
    end
end