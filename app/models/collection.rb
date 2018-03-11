# Represents cards collections
class Collection < ApplicationRecord
  include Localizeable
  extend Nameable

  has_many :cards, dependent: :destroy

  validates :name, :formats, presence: true
  validates :formats, inclusion: { in: %w[standard wild] }

  scope :of_format, ->(format) { where formats: format }
  scope :adventures, -> { where adventure: true }

  def wild?
    formats == 'wild'
  end

  def set_as_wild
    update(formats: 'wild')
    cards.update_all(formats: 'wild')
  end

  def set_as_adventure
    update(adventure: true)
  end
end
