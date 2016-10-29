class Deck < ApplicationRecord
    include Positionable
    
    belongs_to :user
    belongs_to :player
    belongs_to :style

    has_many :checks, dependent: :destroy
    has_many :lines, dependent: :destroy

    validates :name, :playerClass, :user_id, :formats, :player_id, :power, presence: true
    validates :playerClass, inclusion: { in: %w(Priest Warrior Warlock Mage Druid Hunter Shaman Paladin Rogue) }
    validates :formats, inclusion: { in: %w(standard wild) }
    validates :power, inclusion: { in: 1..10 }

    scope :of_player_class, -> (player_class) { where playerClass: player_class }
    scope :of_format, -> (format) { where formats: format }
    scope :of_power, -> (power) { where('power >= ?', power.to_i) }
    scope :of_style, -> (style) { where style_id: Style.return_id_by_name(style) }

    def self.filtered(params)
        decks = all
        return decks if params[:playerClass].nil?
        unless params[:playerClass].empty?
            player = Player.return_by_name(params[:playerClass])
            decks = player.decks if player
        end
        decks = decks.of_power(params[:power]) unless params[:power].empty?
        decks = decks.of_format(params[:formats]) if %w(standard wild).include?(params[:formats])
        decks = decks.of_style(params[:style]) unless params[:style].empty?
        decks
    end

    def self.build(params, user_id)
        data = Parametrize.deck_getting_params(params)
        deck_params, positions_params = data[0][1], data[1]
        return false unless Deck.good_params?(deck_params, positions_params)
        deck = Deck.create name: deck_params['name'], playerClass: deck_params['playerClass'], formats: deck_params['formats'], link: deck_params['link'], caption: deck_params['caption'], author: deck_params['author'], user_id: user_id, player_id: Player.find_by(name_en: deck_params['playerClass']).id, power: deck_params['power'], style_id: Style.return_id_by_name(deck_params['style'])
        deck.build_positions(positions_params)
        deck.calc_price
        deck.check_deck_format
        return true
    end

    def build_positions(positions_params)
        positions, t = [], Time.current
        positions_params.each { |pos| positions.push "(#{pos[0].to_i}, '#{self.id}', 'Deck', '#{pos[1].to_i}', '#{t}', '#{t}')" if pos[1].to_i > 0 }
        Position.connection.execute "INSERT INTO positions (card_id, positionable_id, positionable_type, amount, created_at, updated_at) VALUES #{positions.join(", ")}"
    end

    def refresh(params)
        data = Parametrize.deck_getting_params(params)
        deck_params, positions_params = data[0][1], data[1]
        return false unless Deck.good_params?(deck_params, positions_params, self.playerClass)
        self.update name: deck_params['name'], link: deck_params['link'], caption: deck_params['caption'], author: deck_params['author'], power: deck_params['power'], style_id: Style.return_id_by_name(deck_params['style'])
        self.update_positions(positions_params)
        self.calc_price
        self.check_deck_format
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
        self.positions.each { |pos| price += DustPrice.calc(pos.card.rarity, pos.amount) }
        self.update(price: price)
    end

    def self.check_format
        all.each { |deck| deck.check_deck_format }
    end

    def check_deck_format
        free_cards = 0
        self.cards.each { |card| free_cards += 1 if card.wild_format? }
        self.update(formats: 'wild') if free_cards > 0
    end

    private

    def self.good_params?(deck_params, positions_params, playerClass = nil)
        return false if deck_params.size != 6 && deck_params.size != 8 || positions_params.size == 0
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
