class Deck < ApplicationRecord
    belongs_to :user
    
    has_many :positions
    has_many :cards, through: :positions

    validates :name, :playerClass, :user_id, presence: true
    validates :playerClass, inclusion: { in: %w(Priest Warrior Warlock Mage Druid Hunter Shaman Paladin Rogue) }
end
