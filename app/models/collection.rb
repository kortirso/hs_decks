class Collection < ApplicationRecord
    has_many :cards, dependent: :destroy
    
    validates :name_en, :name_ru, :formats, presence: true
    validates :formats, inclusion: { in: %w(standard wild) }

    scope :of_format, -> (format) { where formats: format }
    scope :adventures, -> { where adventure: true }

    def locale_name(locale)
        self["name_#{locale}"]
    end

    def wild_format?
        formats == 'wild'
    end

    def is_adventure?
        adventure
    end
end
