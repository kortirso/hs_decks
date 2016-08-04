class Deck < ApplicationRecord
    belongs_to :user
    
    has_many :positions, inverse_of: :deck
    has_many :cards, through: :positions

    accepts_nested_attributes_for :positions, allow_destroy: true

    validates :name, :playerClass, :user_id, presence: true
    validates :playerClass, inclusion: { in: %w(Priest Warrior Warlock Mage Druid Hunter Shaman Paladin Rogue) }

    def self.remove_empty_params(params)
        new_params = {}
        params.each { |key, value| new_params[key] = value unless value['amount'].empty? }
        params = new_params
    end

    def self.good_params?(params, playerClass = nil)
        positions = params['deck']['positions_attributes']
        return false if Deck.check_30_cards(positions)
        return false if Deck.check_dublicates(positions)
        return false if Deck.check_class_cards(positions, playerClass.nil? ? params['deck']['playerClass'] : playerClass)
        return true
    end

    def remove_positions(cards)
        ids_new_pos = cards.to_a.select { |pos| pos[1]['amount'] == '1' || pos[1]['amount'] == '2' }.collect { |pos| pos[1]['card_id'].strip }
        positions.each { |pos| pos.destroy unless ids_new_pos.include?(pos.card.name) }
    end

    def build_positions(cards)
        created_cards = cards.to_a.select { |pos| pos[1]['amount'] == '1' || pos[1]['amount'] == '2' }.collect { |pos| pos[1] }
        created_cards.each { |pos| self.positions.create(card: Card.find_by(name: pos['card_id'].strip), amount: pos['amount']) }
    end

    private

    def self.check_30_cards(cards)
        cards.inject(0) { |cards_amount, pos| cards_amount + pos[1]['amount'].to_i } != 30
    end

    def self.check_dublicates(cards)
        ids = cards.to_a.select { |pos| pos[1]['amount'] == '1' || pos[1]['amount'] == '2' }.collect { |pos| pos[1]['card_id'].strip }
        ids.size != ids.uniq.size
    end

    def self.check_class_cards(cards, playerClass)
        ids = cards.to_a.select { |pos| pos[1]['amount'] == '1' || pos[1]['amount'] == '2' }.collect { |pos| pos[1]['card_id'].strip }
        allowed_cards_ids = Card.not_heroes.where(playerClass: nil).or(Card.not_heroes.where(playerClass: playerClass)).to_a.collect { |x| x.name }
        errors = 0
        ids.each { |pos| errors += 1 unless allowed_cards_ids.include? pos }
        errors != 0
    end
end
