class Position < ApplicationRecord
    belongs_to :deck
    belongs_to :card

    validates :amount, :deck_id, :card_id, presence: true
    validates :amount, inclusion: { in: 1..2 }
end
