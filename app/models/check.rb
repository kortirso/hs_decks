class Check < ApplicationRecord
    belongs_to :user
    belongs_to :deck

    validates :user_id, :deck_id, :success, presence: true
end
