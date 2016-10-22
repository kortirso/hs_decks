class Player < ApplicationRecord
    has_many :cards
    has_many :decks

    validates :name_en, :name_ru, presence: true

    def self.names(locale)
        all.collect { |player| player.locale_name(locale) }.sort
    end

    def locale_name(locale)
        self["name_#{locale}"]
    end

    def self.return_en(name)
        return_by_name(name).name_en
    end

    def self.return_by_name(name)
        find_by(name_en: name) || find_by(name_ru: name)
    end
end
