class Deck < ApplicationRecord
    belongs_to :user
    
    has_many :positions
    has_many :cards, through: :positions

    validates :name, :playerClass, :user_id, presence: true
    validates :playerClass, inclusion: { in: %w(Priest Warrior Warlock Mage Druid Hunter Shaman Paladin Rogue) }

    def self.build(params, user_id)
        data = Deck.remove_params(params)
        deck_params, positions_params, decks = data[0..3], data[4..-1], []
        if Deck.good_params?(deck_params, positions_params)
            deck = Deck.new name: deck_params[0][1], playerClass: deck_params[1][1], link: deck_params[2][1], caption: deck_params[3][1], user_id: user_id
            positions_params.each { |pos| deck.positions.build card_id: pos[0].to_i, amount: pos[1].to_i }
            decks << deck
            Deck.import decks, recursive: true
            return true
        end
        return false
    end

    def refresh(params)
        data = Deck.remove_params(params)
        deck_params, positions_params = data[0..2], data[3..-1]
        if Deck.good_params?(deck_params, positions_params, self.playerClass)
            self.update name: deck_params[0][1], link: deck_params[1][1], caption: deck_params[2][1]
            self.update_positions(positions_params)
            return true
        end
        return false
    end

    def update_positions(cards)
        cards = cards.collect { |pos| [pos[0].strip.to_i, pos[1].strip.to_i] }
        cards_ids = cards.collect { |pos| pos[0] }
        old_ids = self.positions.collect_ids.collect { |pos| pos[0] }

        old_ids.each { |pos| cards_ids.include?(pos) ? self.positions.find_by(card_id: pos).update(amount: cards[cards_ids.index(pos)][1]) : self.positions.find_by(card_id: pos).destroy }
        cards_ids.each { |pos| self.positions.create card_id: pos, amount: cards[cards_ids.index(pos)][1] unless old_ids.include?(pos) }
    end

    private

    def self.remove_params(params)
        return params.permit!.to_h.to_a.delete_if { |elem| elem[0] == 'utf8' || elem[0] == 'commit' || elem[0] == 'authenticity_token' || elem[0] == 'controller' || elem[0] == 'action' || elem[0] == 'id' || elem[0] == '_method' }
    end

    def self.good_params?(deck_params, positions_params, playerClass = nil)
        return false if Deck.check_deck_params(deck_params)
        return false if Deck.check_30_cards(positions_params)
        return false if Deck.check_dublicates(positions_params)
        return false if Deck.check_cards_class(positions_params, playerClass.nil? ? deck_params[1][1] : playerClass)
        return true
    end

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
        allowed_cards_ids = Card.where(playerClass: nil).or(Card.not_heroes.where(playerClass: playerClass)).to_a.collect { |x| x.id }
        errors = 0
        ids.each { |pos| errors += 1 unless allowed_cards_ids.include? pos }
        errors != 0
    end
end
