# Represents player classes
class Player < ApplicationRecord
  include Localizeable
  extend Nameable

  belongs_to :multi_class, optional: true

  has_many :cards, dependent: :destroy
  has_many :decks, dependent: :destroy

  validates :name, presence: true

  scope :is_playable, -> { where playable: true }
end
