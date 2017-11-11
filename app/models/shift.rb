# Represents shifts for cards
class Shift < ApplicationRecord
    belongs_to :card
    belongs_to :change, class_name: 'Card'

    validates :card_id, :change_id, :priority, presence: true
end
