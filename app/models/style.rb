class Style < ApplicationRecord
    has_many :decks

    validates :name_en, :name_ru, presence: true, uniqueness: true

    def self.get_names(locale)
        all.collect { |style| style["name_#{locale}"] }
    end

    def self.return_id_by_name(name)
        style = find_by(name_en: name) || find_by(name_ru: name)
        return style.nil? ? nil : style.id
    end

    def locale_name(locale)
        self["name_#{locale}"]
    end
end
