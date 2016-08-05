class Position < ApplicationRecord
    belongs_to :deck
    belongs_to :card

    validates :amount, :deck_id, :card_id, presence: true
    validates :amount, inclusion: { in: 1..2 }

    def self.collect_ids
        ids = []
        all.each { |pos| ids.push [pos.card_id, pos.amount] }
        return ids
    end
end
