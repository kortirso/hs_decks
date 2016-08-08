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
end
