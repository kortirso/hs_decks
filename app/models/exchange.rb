# Represents exchanges for cards
class Exchange < ApplicationRecord
    belongs_to :position
    belongs_to :card

    validates :position_id, :card_id, presence: true
end
