require 'babosa'

# Represents deckss
class Deck < ApplicationRecord
  include Localizeable
  include Positionable
  extend FriendlyId

  friendly_id :slug_candidates, use: :slugged

  belongs_to :user
  belongs_to :player
  belongs_to :style, optional: true
  belongs_to :race, optional: true

  has_many :checks, dependent: :destroy
  has_many :lines, dependent: :destroy
  has_many :mulligans, dependent: :destroy

  validates :name, :playerClass, :user_id, :formats, :player_id, :power, presence: true
  validates :playerClass, inclusion: { in: %w[Priest Warrior Warlock Mage Druid Hunter Shaman Paladin Rogue] }
  validates :formats, inclusion: { in: %w[standard wild] }
  validates :power, inclusion: { in: 1..10 }

  scope :of_player_class, ->(player_class) { where playerClass: player_class }
  scope :of_format, ->(format) { where formats: format }
  scope :of_power, ->(power) { where('power >= ?', power.to_i) }
  scope :of_style, ->(style) { where style_id: Style.return_id_by_name(style) }

  after_create :build_mulligan

  def slug_candidates
    [:name, %i[name user_id], %i[name user_id id]]
  end

  def normalize_friendly_id(input)
    input.to_s.to_slug.normalize(transliterations: :russian).to_s
  end

  def locale_caption(locale)
    locale == 'en' ? caption_en : caption
  end

  def self.check_format
    all.includes(:cards).each(&:check_deck_format)
  end

  def check_deck_format(free_cards = 0)
    cards.each { |card| free_cards += 1 if card.wild? }
    update(formats: 'wild') if free_cards > 0
  end

  def wild?
    formats == 'wild'
  end

  def convert_to_standard
    update(formats: 'standard')
    positions.each { |p| p.destroy if p.card.wild? }
  end

  private def build_mulligan
    Player.is_playable.each { |player| Mulligan.create deck_id: id, player_id: player.id }
  end
end
