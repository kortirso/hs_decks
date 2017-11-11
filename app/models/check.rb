# Represents checks
class Check < ApplicationRecord
    include Positionable

    belongs_to :user
    belongs_to :deck

    has_one :substitution, dependent: :destroy

    validates :user_id, :deck_id, :success, presence: true

    scope :of_user, ->(user_id) { where user_id: user_id }
end
