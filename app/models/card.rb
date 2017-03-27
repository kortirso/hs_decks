class Card < ApplicationRecord
    self.inheritance_column = nil

    belongs_to :collection
    belongs_to :player
    belongs_to :multi_class

    has_many :positions, dependent: :destroy
    has_many :decks, through: :positions, source: :positionable, source_type: 'Deck'
    has_many :users, through: :positions, source: :positionable, source_type: 'User'
    has_many :checks, through: :positions, source: :positionable, source_type: 'Check'
    has_many :mulligans, through: :positions, source: :positionable, source_type: 'Mulligan'
    has_many :lines
    has_many :shifts, dependent: :destroy
    has_many :exchanges, through: :shifts, source: :change

    validates :cardId, :name_en, :type, :rarity, :collection_id, :formats, :usable, presence: true
    validates :type, inclusion: { in: %w(Hero Spell Minion Weapon) }
    validates :playerClass, inclusion: { in: %w(Priest Warrior Warlock Mage Druid Hunter Shaman Paladin Rogue Neutral) }
    validates :multiClassGroup, inclusion: { in: %w(Grimy\ Goons Jade\ Lotus Kabal) }, allow_nil: true
    validates :rarity, inclusion: { in: %w(Free Common Rare Epic Legendary) }
    validates :formats, inclusion: { in: %w(standard wild) }

    scope :not_heroes, -> { where.not(cost: nil) }
    scope :of_type, -> (type) { where type: type }
    scope :for_all_classes, -> { where playerClass: 'Neutral' }
    scope :of_player_class, -> (player_class) { where playerClass: player_class }
    scope :of_rarity, -> (rarity) { where rarity: rarity }
    scope :not_free, -> { where.not(rarity: 'Free') }
    scope :of_format, -> (formats) { where formats: formats }
    scope :crafted, -> { where craft: true }
    scope :unusable, -> { where usable: 0 }

    def self.return_by_name(name)
        find_by(name_en: name) || find_by(name_ru: name)
    end

    def self.with_cost(cost)
        cost < 7 ? where(cost: cost) : where('cost >= 7')
    end

    def self.with_shifts(cards = [])
        Shift.pluck(:card_id).uniq.each { |id| cards.push Card.find(id) }
        cards.sort_by { |card| card.cost }
    end

    def locale_name(locale)
        self["name_#{locale}"]
    end

    def wild_format?
        formats == 'wild' || in_hall_of_fame?
    end

    def in_hall_of_fame?
        hall_of_fame
    end

    def is_crafted?
        craft
    end

    def is_legendary?
        rarity == 'Legendary'
    end
end
