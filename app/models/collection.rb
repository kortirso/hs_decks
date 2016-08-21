class Collection < ApplicationRecord
    has_many :cards, dependent: :destroy
    
    validates :name, :formats, presence: true
    validates :formats, inclusion: { in: %w(standard wild) }

    scope :of_format, -> (format) { where formats: format }

    def wild_format?
        self.formats == 'wild'
    end

    def self.added
        all.to_a.select { |c| c.cards.size == 0 }
    end

    def self.add_new_collection
        Collection.added.each { |c| c.add_new_cards }
    end

    def add_new_cards
        Message.new.get_request[self.name].each do |card|
            self.cards.create cardId: card['cardId'], name_en: card['name'], type: card['type'], cost: card['cost'], playerClass: card['playerClass'], rarity: card['rarity'], image_en: card['img']
        end
    end
end
