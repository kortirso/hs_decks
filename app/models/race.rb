# Represents reces
class Race < ApplicationRecord
  include Localizeable
  extend Nameable

  has_many :cards
  has_many :decks

  validates :name, presence: true
end
