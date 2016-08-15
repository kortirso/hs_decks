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
        deck_params, positions_params = data[0].to_h, data[1]
        return false unless Deck.good_params?(deck_params, positions_params)
        deck = Deck.create name: deck_params['name'], playerClass: deck_params['playerClass'], formats: deck_params['formats'], link: deck_params['link'], caption: deck_params['caption'], author: deck_params['author'], user_id: user_id
        deck.build_positions(positions_params)
        deck.calc_price
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
        deck_params, positions_params = data[0].to_h, data[1]
        return false unless Deck.good_params?(deck_params, positions_params, self.playerClass)
        self.update name: deck_params['name'], link: deck_params['link'], caption: deck_params['caption']
        self.update_positions(positions_params)
        self.calc_price
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

    def calc_price
        price = 0
        self.positions.each { |pos| price += Position.dust_card_price(pos.card.rarity, pos.amount) }
        self.update(price: price)
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
        data = params.permit!.to_h.to_a.delete_if { |elem| elem[0] == 'utf8' || elem[0] == 'commit' || elem[0] == 'authenticity_token' || elem[0] == 'controller' || elem[0] == 'action' || elem[0] == 'id' || elem[0] == '_method' || elem[0] == 'mana_cost' }
        deck_params, positions_params = [], []
        data.each { |d| d[0] == 'name' || d[0] == 'playerClass' || d[0] == 'formats' || d[0] == 'link' || d[0] == 'caption' || d[0] == 'success' || d[0] == 'author' ? deck_params.push(d) : positions_params.push(d) }
        return [deck_params, positions_params]
    end

    def self.good_params?(deck_params, positions_params, playerClass = nil)
        return false if deck_params.size != 4 && deck_params.size != 6 || positions_params.size == 0
        return false if Deck.check_deck_params(deck_params, playerClass.nil? ? 1 : 0)
        return false if Deck.check_30_cards(positions_params)
        return false if Deck.check_dublicates(positions_params)
        return false if Deck.check_cards_class(positions_params, playerClass.nil? ? deck_params['playerClass'] : playerClass)
        ## todo: check card format
        ## todo: check 1 legendary
        return true
    end

    def self.check_deck_params(deck, met)
        if met == 1
            return deck['name'].empty? || deck['playerClass'].empty? || deck['formats'].empty?
        else
            return deck['name'].empty?
        end
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
