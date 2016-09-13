class Player < ApplicationRecord
    has_many :cards
    has_many :decks

    validates :name_en, :name_ru, presence: true

    def locale_name(locale)
        self["name_#{locale}"]
    end

    def self.names(locale)
        all.to_a.collect { |player| player["name_#{locale}"] }.sort
    end

    def self.return_en(name)
        (find_by(name_en: name) || find_by(name_ru: name)).name_en
    end
end
