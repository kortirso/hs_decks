class Collection < ApplicationRecord
    has_many :cards, dependent: :destroy
    
    validates :name, :formats, presence: true
    validates :formats, inclusion: { in: %w(standard wild) }

    scope :of_format, -> (format) { where formats: format }

    def wild_format?
        self.formats == 'wild'
    end
end
