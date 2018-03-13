# Represents mulligans
class Mulligan < ApplicationRecord
  include Positionable

  belongs_to :deck
  belongs_to :player

  validates :deck_id, :player_id, presence: true
end
