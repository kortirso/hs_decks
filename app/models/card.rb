class Card < ApplicationRecord
    self.inheritance_column = nil

    belongs_to :collection
    belongs_to :player

    has_many :positions, dependent: :destroy
    has_many :decks, through: :positions, source: :positionable, source_type: 'Deck'
    has_many :users, through: :positions, source: :positionable, source_type: 'User'
    has_many :checks, through: :positions, source: :positionable, source_type: 'Check'

    has_many :shifts, dependent: :destroy
    has_many :exchanges, through: :shifts, source: :change

    validates :cardId, :name_en, :type, :rarity, :collection_id, :formats, presence: true
    validates :type, inclusion: { in: %w(Hero Spell Minion Weapon) }
    validates :playerClass, inclusion: { in: %w(Priest Warrior Warlock Mage Druid Hunter Shaman Paladin Rogue) }, allow_nil: true
    validates :rarity, inclusion: { in: %w(Free Common Rare Epic Legendary) }
    validates :formats, inclusion: { in: %w(standard wild) }

    scope :not_heroes, -> { where.not(cost: nil) }
    scope :of_type, -> (type) { where type: type }
    scope :for_all_classes, -> { where playerClass: nil }
    scope :of_player_class, -> (player_class) { where playerClass: player_class }
    scope :of_rarity, -> (rarity) { where rarity: rarity }
    scope :of_format, -> (format) { where formats: format }

    def self.with_cost(cost)
        return cost < 7 ? where(cost: cost) : where('cost >= 7')
    end

    def wild_format?
        self.formats == 'wild'
    end

    def self.check_cards_format
        Collection.of_format('wild').includes(:cards).each { |collection| collection.cards.update_all(formats: 'wild') unless collection.cards.last.wild_format? }
    end

    def self.check_locale(locale)
        result = Message.new(locale).get_request
        Collection.all.includes(:cards).each do |collection|
            result[collection.name_en].each do |card|
                current = collection.cards.find_by(cardId: card['cardId'])
                current.refresh_params(locale, card) if current
            end
        end
    end

    def refresh_params(locale, card)
        self["name_#{locale}"] = card['name']
        self["image_#{locale}"] = card['img']
        self.type = card['type']
        self.cost = card['cost']
        self.playerClass = card['playerClass']
        self.player_id = Player.find_by(name_en: card['playerClass']) unless card['playerClass'].nil?
        self.rarity = card['rarity']
        self.save if self.changed?
    end
end
