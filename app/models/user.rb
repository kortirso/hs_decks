# Represents users
class User < ApplicationRecord
    include Positionable

    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

    has_many :decks
    has_many :checks

    validates :role, :username, presence: true
    validates :role, inclusion: { in: %w[user deck_master] }
    validates :username, uniqueness: true, length: { in: 1..20 }

    scope :news_subscribers, -> { where get_news: true }

    #after_create :welcome_notify

    def deck_master?
        role == 'deck_master'
    end

    def unusable_cards
        cards.not_free.select { |card| card.usable.zero? }.sort_by(&:cost)
    end

    def subscribe_for_news
        update(get_news: true) unless get_news
    end

    def unsubscribe_from_news
        update(get_news: false) if get_news
    end

    private

    def welcome_notify
        WelcomeletterJob.perform_later(self)
    end
end
