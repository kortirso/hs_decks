class Substitution < ApplicationRecord
    include Positionable

    belongs_to :check

    validates :check_id, presence: true

    def self.find_exchange(card_id, amount, playerClass, pos_ids, subs_ids)
        exchanged = Card.find_by(id: card_id)
        exchanged.shifts.order(priority: :desc).each do |shift|
            return [shift.change.id, amount] if (shift.change.playerClass.nil? || shift.change.playerClass == playerClass) && !pos_ids.include?(shift.change.id) && !subs_ids.include?(shift.change.id)
        end
        cards_for_random = Card.for_all_classes.of_rarity('Free').with_cost(exchanged.cost).or(Card.not_heroes.of_player_class(playerClass).of_rarity('Free').with_cost(exchanged.cost)).to_a.delete_if { |card| pos_ids.include?(card.id) || subs_ids.include?(card.id) || card.id == card_id }
        return cards_for_random.size > 0 ? [cards_for_random.sample.id, amount] : [card_id, amount]
    end
end
