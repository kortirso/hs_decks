class Deck < ApplicationRecord
    include Positionable
    
    belongs_to :user

    has_many :checks, dependent: :destroy

    validates :name, :playerClass, :user_id, :formats, presence: true
    validates :playerClass, inclusion: { in: %w(Priest Warrior Warlock Mage Druid Hunter Shaman Paladin Rogue) }
    validates :formats, inclusion: { in: %w(standard wild) }

    scope :of_player_class, -> (player_class) { where playerClass: player_class }
    scope :of_format, -> (format) { where formats: format }

    def self.build(params, user_id)
        data = Deck.remove_params(params)
        deck_params, positions_params, decks = data[0..5], data[6..-1], []
        return false unless Deck.good_params?(deck_params, positions_params)
        deck = Deck.create name: deck_params[0][1], playerClass: deck_params[1][1], formats: deck_params[2][1], link: deck_params[3][1], caption: deck_params[4][1], user_id: user_id
        deck.build_positions(positions_params)
        return true
    end

    def build_positions(positions_params)
        positions, t = [], Time.current
        positions_params.each { |pos| positions.push "(#{pos[0].to_i}, '#{self.id}', 'Deck', '#{pos[1].to_i}', '#{t}', '#{t}')" if pos[1].to_i > 0 }
        Position.connection.execute "INSERT INTO positions (card_id, positionable_id, positionable_type, amount, created_at, updated_at) VALUES #{positions.join(", ")}"
        ## todo: add removing cards
    end

    def refresh(params)
        data = Deck.remove_params(params)
        deck_params, positions_params = data[0..3], data[4..-1]
        return false unless Deck.good_params?(deck_params, positions_params, self.playerClass)
        self.update name: deck_params[0][1], link: deck_params[1][1], caption: deck_params[2][1]
        self.update_positions(positions_params)
        ## todo: check all cards for format changing
        return true
    end

    def update_positions(cards)
        cards = cards.collect { |pos| [pos[0].strip.to_i, pos[1].strip.to_i] }
        cards_ids = cards.collect { |pos| pos[0] }
        old_ids = self.positions.collect_ids.collect { |pos| pos[0] }

        old_ids.each do |pos|
            if cards_ids.include?(pos) && cards[cards_ids.index(pos)][1] > 0
                self.positions.find_by(card_id: pos).update(amount: cards[cards_ids.index(pos)][1])
            else
                self.positions.find_by(card_id: pos).destroy
            end
        end
        cards_ids.each { |pos| self.positions.create card_id: pos, amount: cards[cards_ids.index(pos)][1] unless old_ids.include?(pos) }
    end

    def self.check_format
        all.each { |deck| deck.check_deck_format }
    end

    def check_deck_format
        free_cards = 0
        self.cards.includes(:collection).each { |card| free_cards += 1 if card.collection.wild_format? }
        self.update(formats: 'wild') if free_cards > 0
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
        ## todo: check card format
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
        allowed_cards_ids = Card.for_all_classes.or(Card.not_heroes.of_player_class(playerClass)).collect { |x| x.id }
        errors = 0
        ids.each { |pos| errors += 1 unless allowed_cards_ids.include? pos }
        errors != 0
    end
end
