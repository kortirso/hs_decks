class Line < ApplicationRecord
    belongs_to :deck
    belongs_to :card

    validates :deck_id, :card_id, :max_amount, :priority, presence: true
end