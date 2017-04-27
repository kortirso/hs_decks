class Race < ApplicationRecord
    has_many :cards
    has_many :decks
end
