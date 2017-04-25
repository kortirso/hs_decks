class Race < ApplicationRecord
    has_many :cards
    has_many :decks

    def self.get_names(locale)
        all.collect { |object| object["name_#{locale}"] }
    end

    def self.return_id_by_name(name)
        object = find_by(name_en: name) || find_by(name_ru: name)
        object.nil? ? nil : object.id
    end

    def locale_name(locale)
        self["name_#{locale}"]
    end
end
