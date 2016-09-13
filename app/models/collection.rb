class Collection < ApplicationRecord
    has_many :cards, dependent: :destroy
    
    validates :name_en, :name_ru, :formats, presence: true
    validates :formats, inclusion: { in: %w(standard wild) }

    scope :of_format, -> (format) { where formats: format }
    scope :adventures, -> { where adventure: true }

    def locale_name(locale)
        self["name_#{locale}"]
    end

    def wild_format?
        self.formats == 'wild'
    end

    def is_adventure?
        self.adventure
    end

    def self.added
        all.to_a.select { |c| c.cards.size == 0 }
    end

    def self.add_new_collection
        Collection.added.each { |c| c.add_new_cards }
    end

    def add_new_cards
        Message.new.get_request[self.name_en].each do |card|
            self.cards.create cardId: card['cardId'], name_en: card['name'], type: card['type'], cost: card['cost'], playerClass: card['playerClass'], rarity: card['rarity'], image_en: card['img']
        end
    end
end
