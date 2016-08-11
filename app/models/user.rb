class User < ApplicationRecord
    include Positionable

    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

    has_many :decks
    has_many :checks

    validates :role, presence: true
    validates :role, inclusion: { in: %w(user deck_master) }

    def deck_master?
        self.role == 'deck_master'
    end

    def build_collection(params)
        old = self.positions.collect_ids
        cards = Deck.remove_params(params)[1].map { |elem| elem.map { |x| x.to_i } }
        if cards.size > 0
            cards_ids = cards.collect { |i| i[0] }
            old_ids = old.collect { |i| i[0] }
            self.update_collection(old_ids, cards_ids, cards, old)
            self.adding_to_collection(old_ids, cards_ids, cards)
        end
    end

    def update_collection(old_ids, cards_ids, cards, old)
        positions = self.positions
        old_ids.each do |old_id|
            if cards_ids.include?(old_id)
                new_amount = cards[cards_ids.index(old_id)][1]
                positions.find_by(card_id: old_id).update(amount: new_amount) if old[old_ids.index(old_id)][1] != new_amount
            else
                positions.find_by(card_id: old_id).destroy
            end
        end
    end

    def adding_to_collection(old_ids, cards_ids, cards)
        positions, t = [], Time.current
        cards_ids.each { |id| positions.push "(#{id}, '#{self.id}', 'User', '#{cards[cards_ids.index(id)][1]}', '#{t}', '#{t}')" unless old_ids.include?(id) }
        Position.connection.execute "INSERT INTO positions (card_id, positionable_id, positionable_type, amount, created_at, updated_at) VALUES #{positions.join(", ")}"
    end
end
