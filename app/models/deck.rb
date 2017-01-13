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

    def self.check_format
        all.includes(:cards).each { |deck| deck.check_deck_format }
    end

    def check_deck_format(free_cards = 0)
        cards.each { |card| free_cards += 1 if card.wild_format? }
        update(formats: 'wild') if free_cards > 0
    end

    def is_reno_type?
        reno_type
    end
end
