# Represents decks styles
class Style < ApplicationRecord
  include Localizeable
  extend Nameable

  has_many :decks

  validates :name, presence: true
end
