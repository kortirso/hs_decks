# Represents cards collections
class Collection < ApplicationRecord
    has_many :cards, dependent: :destroy

    validates :name_en, :name_ru, :formats, presence: true
    validates :formats, inclusion: { in: %w[standard wild] }

    scope :of_format, ->(format) { where formats: format }
    scope :adventures, -> { where adventure: true }

    def wild_format?
        formats == 'wild'
    end

    def set_as_wild
        update(formats: 'wild')
        cards.update_all(formats: 'wild')
    end

    def set_as_adventure
        update(adventure: true)
    end
end
