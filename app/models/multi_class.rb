# Represents multiclasses
class MultiClass < ApplicationRecord
  include Localizeable
  extend Nameable

  has_many :players
  has_many :cards

  validates :name, presence: true
end
