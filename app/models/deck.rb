class Deck < ApplicationRecord
    belongs_to :user
    
    has_many :positions
    has_many :cards, through: :positions

    validates :name, :playerClass, :user_id, presence: true
    validates :playerClass, inclusion: { in: %w(Priest Warrior Warlock Mage Druid Hunter Shaman Paladin Rogue) }

    def self.remove_params(params)
        params.permit!
        return params.to_h.to_a.delete_if { |elem| elem[0] == 'utf8' || elem[0] == 'commit' || elem[0] == 'authenticity_token' || elem[0] == 'controller' || elem[0] == 'action' }
    end

    def self.good_params?(data)
        deck_params, positions_params = data[0..3], data[4..-1]
        return false if Deck.check_deck_params(deck_params)
        return false if Deck.check_30_cards(positions_params)
        return false if Deck.check_dublicates(positions_params)
        return false if Deck.check_cards_class(positions_params, deck_params[1][1])
        return true
    end

    def self.build(params, user_id)
        data = Deck.remove_params(params)
        if Deck.good_params?(data)
            deck_params, positions_params, decks = data[0..3], data[4..-1], []
            deck = Deck.new name: deck_params[0][1], playerClass: deck_params[1][1], link: deck_params[2][1], caption: deck_params[3][1], user_id: user_id
            positions_params.each { |pos| deck.positions.build card_id: pos[0].to_i, amount: pos[1].to_i }
            decks << deck
            Deck.import decks, recursive: true
            return true
        end
        return false
    end

    private

    def self.check_deck_params(deck)
        deck[0][1].empty? 
    end

    def self.check_30_cards(cards)
        cards_amount = 0
        cards.each { |pos| cards_amount += pos[1].to_i }
        cards_amount != 30
    end

    def self.check_dublicates(cards)
        ids = cards.collect { |pos| pos[0].strip }
        ids.size != ids.uniq.size
    end

    def self.check_cards_class(cards, playerClass)
        ids = cards.collect { |pos| pos[0].strip.to_i }
        allowed_cards_ids = Card.not_heroes.where(playerClass: nil).or(Card.where(playerClass: playerClass)).to_a.collect { |x| x.id }
        errors = 0
        ids.each { |pos| errors += 1 unless allowed_cards_ids.include? pos }
        errors != 0
    end
end
