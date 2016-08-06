class User < ApplicationRecord
    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

    has_many :packs, dependent: :destroy
    has_many :cards, through: :packs

    has_many :decks
    has_many :checks

    validates :role, presence: true
    validates :role, inclusion: { in: %w(user deck_master) }

    def deck_master?
        return self.role == 'deck_master' ? true : false
    end

    def check_decks
        self.checks.destroy_all
        checks = []
        cards_ids = self.packs.collect_ids
        Deck.all.includes(:positions).each do |deck|
            check = self.checks.new deck_id: deck.id, success: self.check_deck(cards_ids, deck.positions.collect_ids)
            checks << check
        end
        Check.import checks
    end

    def check_deck(cards, positions)
        result = 0
        cards_ids = cards.collect { |i| i[0] }
        pos_ids = positions.collect { |i| i[0] }
        pos_ids.each do |pos|
            if cards_ids.include?(pos)
                cards[cards_ids.index(pos)][1] >= positions[pos_ids.index(pos)][1] ? result += positions[pos_ids.index(pos)][1] : result += 1
            end
        end
        (result * 100) / 30
    end
end
