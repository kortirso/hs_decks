class Pack < ApplicationRecord
    belongs_to :user
    belongs_to :card

    validates :amount, :user_id, :card_id, presence: true
    validates :amount, inclusion: { in: 1..2 }

    def self.collect_ids
        ids = []
        all.each { |pack| ids.push [pack.card_id, pack.amount] }
        return ids
    end

    def self.build(user_id, params, old)
        cards = Deck.remove_params(params).map { |elem| elem.map { |x| x.to_i } }
        cards_ids = cards.collect { |i| i[0] }
        old_ids = old.collect { |i| i[0] }
        old_ids.each do |old_id|
            if cards_ids.include?(old_id)
                new_amount = cards[cards_ids.index(old_id)][1]
                Pack.find_by(card_id: old_id, user_id: user_id).update(amount: new_amount) if old[old_ids.index(old_id)][1] != new_amount
            else
                Pack.find_by(card_id: old_id, user_id: user_id).destroy
            end
        end
        packs = []
        cards_ids.each { |id| packs << Pack.new(card_id: id, user_id: user_id, amount: cards[cards_ids.index(id)][1]) unless old_ids.include?(id) }
        Pack.import packs
    end
end
