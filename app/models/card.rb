class Card < ApplicationRecord
    self.inheritance_column = nil

    belongs_to :collection

    validates :cardId, :name, :type, :rarity, :collection_id, presence: true
    validates :type, inclusion: { in: %w(Hero Spell Minion Weapon) }
    validates :playerClass, inclusion: { in: %w(Priest Warrior Warlock Mage Druid Hunter Shaman Paladin Rogue) }, allow_nil: true
    validates :rarity, inclusion: { in: %w(Free Common Rare Epic Legendary) }

    scope :of_type, -> (type) { where type: type }
    scope :of_player_class, -> (player_class) { where playerClass: player_class }
    scope :of_rarity, -> (rarity) { where rarity: rarity }
    scope :with_cost, -> (cost) { where cost: cost }
    scope :overpowered, -> { where('cost >= 7') }
end
