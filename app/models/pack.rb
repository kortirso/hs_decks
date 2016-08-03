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

    def self.build(user_id, params, old_ids)
        packs = []
        ids = params.to_a.delete_if { |elem| elem[0] == 'utf8' || elem[0] == 'commit' }.map { |elem| elem.map { |x| x.to_i } }
        ids_only_id = ids.collect { |i| i[0] }
        old_ids_only_id = old_ids.collect { |i| i[0] }
        old_ids.each do |old_id|
            if ids_only_id.include?(old_id[0])
                new_amount = ids[ids_only_id.index(old_id[0])][1]
                Pack.find_by(card_id: old_id[0], user_id: user_id).update(amount: new_amount) if old_id[1] != new_amount
            else
                Pack.find_by(card_id: old_id[0], user_id: user_id).destroy
            end
        end
        ids.each { |id| packs << Pack.new(card_id: id[0], user_id: user_id, amount: id[1]) unless old_ids_only_id.include?(id[0]) }
        Pack.import packs
    end
end
