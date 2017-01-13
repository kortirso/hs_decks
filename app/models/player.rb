class Player < ApplicationRecord
    belongs_to :multi_class
    
    has_many :cards
    has_many :decks

    validates :name_en, :name_ru, presence: true

    scope :is_playable, -> { where playable: true }

    def self.names(locale)
        all.collect { |player| player.locale_name(locale) }.sort
    end

    def self.return_en(name)
        return_by_name(name).name_en
    end

    def self.return_by_name(name)
        find_by(name_en: name) || find_by(name_ru: name)
    end

    def locale_name(locale)
        self["name_#{locale}"]
    end
end
