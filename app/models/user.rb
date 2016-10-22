class User < ApplicationRecord
    include Positionable

    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

    has_many :decks
    has_many :checks

    validates :role, :username, presence: true
    validates :role, inclusion: { in: %w(user deck_master) }
    validates :username, uniqueness: true, length: { in: 1..20 }

    scope :news_subscribers, -> { where get_news: true }

    after_create :welcome_notify

    def deck_master?
        self.role == 'deck_master'
    end

    def build_collection(params)
        old = self.positions.collect_ids
        params = Parametrize.deck_getting_params(params)
        cards = params[1].map { |elem| elem.map { |x| x.to_i } }
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
                if new_amount.zero?
                    positions.find_by(card_id: old_id).destroy
                else
                    positions.find_by(card_id: old_id).update(amount: new_amount) if old[old_ids.index(old_id)][1] != new_amount
                end
            end
        end
    end

    def adding_to_collection(old_ids, cards_ids, cards)
        pos, t = [], Time.current
        cards_ids.each { |id| pos.push "(#{id}, '#{self.id}', 'User', '#{cards[cards_ids.index(id)][1]}', '#{t}', '#{t}')" if !old_ids.include?(id) && cards[cards_ids.index(id)][1] != 0 }
        Position.connection.execute "INSERT INTO positions (card_id, positionable_id, positionable_type, amount, created_at, updated_at) VALUES #{pos.join(", ")}" if pos.size > 0
    end

    def get_unusable_cards
        cards_for_destroy, unused_cards = [], Card.not_heroes.not_free.unusable.to_a
        self.cards.not_free.to_a.each do |user_card|
            cards_for_destroy.push(user_card) if unused_cards.include?(user_card)
        end
        cards_for_destroy
    end

    def subscribe_for_news
        self.update(get_news: true) unless self.get_news
    end

    def unsubscribe_from_news
        self.update(get_news: false) if self.get_news
    end

    def hearthpwn_collection(params)
        UploadCollectionJob.perform_later(self, params[:username])
    end

    private

    def welcome_notify
        WelcomeletterJob.perform_later(self)
    end
end
