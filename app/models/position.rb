# represents positions in deck like objects
class Position < ApplicationRecord
  belongs_to :positionable, polymorphic: true
  belongs_to :card

  has_many :exchanges

  validates :amount, :positionable_id, :positionable_type, :card_id, presence: true
  validates :amount, inclusion: { in: 0..2 }

  def self.sorted_by_cards
    locale = I18n.locale
    all.to_a.sort_by { |elem| [elem.card.cost, elem.card.locale_name(locale)] }
  end

  def self.collect_ids(ids = [])
    all.order(id: :asc).each { |pos| ids.push [pos.card_id, pos.amount] }
    ids
  end

  def self.collect_ids_as_hash(ids = {})
    all.order(id: :asc).each { |pos| ids[pos.card_id.to_s] = pos.amount }
    ids
  end

  def self.collect_ids_with_caption(ids = [])
    all.order(id: :asc).each { |pos| ids.push [pos.card_id, pos.amount, pos.caption] }
    ids
  end

  def self.collect_ids_with_rarity(ids = [])
    all.includes(:card).order(id: :asc).each { |pos| ids.push [pos.card_id, pos.amount, pos.card.rarity, pos.card.craft?] }
    ids
  end

  def self.collect_ids_with_rarity_as_hash(ids = {})
    all.includes(:card).order(id: :asc).each { |pos| ids[pos.card_id.to_s] = { amount: pos.amount, rarity: pos.card.rarity, crafted: pos.card.craft? } }
    ids
  end

  def self.with_sorted_cards(locale = 'en', cards = [])
    all.each { |pos| cards.push pos.card }
    cards.sort_by { |card| [card.cost, card.locale_name(locale)] }
  end

  def self.amount_by_mana(result = [0, 0, 0, 0, 0, 0, 0, 0])
    all.includes(:card).each { |pos| result[pos.card.cost < 7 ? pos.card.cost : 7] += pos.amount }
    result
  end

  def musthave(value)
    update(must_have: value)
  end
end
