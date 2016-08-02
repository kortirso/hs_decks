class Pack < ApplicationRecord
    belongs_to :user
    belongs_to :card

    validates :amount, :user_id, :card_id, presence: true
    validates :amount, inclusion: { in: 1..2 }

    def self.collect_ids
        ids = []
        all.each { |pack| ids.push pack.card_id }
        return ids
    end

    def self.build(user_id, params, old_ids)
        packs = []
        ids = params.to_a.collect { |elem| elem[0] }.delete_if { |elem| elem == 'utf8' || elem == 'commit' }.map { |elem| elem.to_i }
        old_ids.each { |old_id| Pack.find_by(card_id: old_id, user_id: user_id).destroy unless ids.include?(old_id) }
        ids.each { |id| packs << Pack.new(card_id: id, user_id: user_id, amount: 1) unless old_ids.include?(id) }
        Pack.import packs
    end
end
