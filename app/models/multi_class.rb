# Represents multiclasses
class MultiClass < ApplicationRecord
  extend Nameable

  has_many :players
  has_many :cards

  validates :name, presence: true
end
