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
end
