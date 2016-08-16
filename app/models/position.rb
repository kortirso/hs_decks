class Position < ApplicationRecord
    belongs_to :positionable, polymorphic: true
    belongs_to :card

    validates :amount, :positionable_id, :card_id, presence: true
    validates :amount, inclusion: { in: 0..2 }

    def self.collect_ids
        ids = []
        all.order(id: :asc).each { |pos| ids.push [pos.card_id, pos.amount] }
        return ids
    end

    def self.collect_ids_with_rarity
        ids = []
        all.includes(:card).order(id: :asc).each { |pos| ids.push [pos.card_id, pos.amount, pos.card.rarity] }
        return ids
    end

    def self.with_sorted_cards(locale)
        cards = []
        all.each { |pos| cards.push pos.card }
        return cards.sort_by { |card| [card.cost, card["name_#{locale}"]] }
    end
end
