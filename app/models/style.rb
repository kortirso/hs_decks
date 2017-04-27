class Style < ApplicationRecord
    has_many :decks

    validates :name_en, :name_ru, presence: true, uniqueness: true
end
