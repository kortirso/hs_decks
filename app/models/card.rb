class Card < ApplicationRecord
    self.inheritance_column = nil

    belongs_to :collection

    has_many :packs, dependent: :destroy
    has_many :users, through: :packs

    has_many :positions, dependent: :destroy
    has_many :decks, through: :positions

    validates :cardId, :name, :type, :rarity, :collection_id, :formats, presence: true
    validates :type, inclusion: { in: %w(Hero Spell Minion Weapon) }
    validates :playerClass, inclusion: { in: %w(Priest Warrior Warlock Mage Druid Hunter Shaman Paladin Rogue) }, allow_nil: true
    validates :rarity, inclusion: { in: %w(Free Common Rare Epic Legendary) }
    validates :formats, inclusion: { in: %w(standard free) }

    scope :not_heroes, -> { where.not(cost: nil) }
    scope :of_type, -> (type) { where type: type }
    scope :for_all_classes, -> { where playerClass: nil }
    scope :of_player_class, -> (player_class) { where playerClass: player_class }
    scope :of_rarity, -> (rarity) { where rarity: rarity }
    scope :of_format, -> (format) { where formats: format }

    def self.with_cost(cost)
        return cost < 7 ? where(cost: cost) : where('cost >= 7')
    end

    def self.check_cards_format
        Collection.of_format('free').includes(:cards).each { |collection| collection.cards.each { |card| card.update(formats: 'free') } }
    end
end
