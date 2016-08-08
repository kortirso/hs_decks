class Collection < ApplicationRecord
    has_many :cards, dependent: :destroy
    
    validates :name, :formats, presence: true
    validates :name, inclusion: { in: %w(Basic Classic Promo Reward Naxxramas Goblins\ vs\ Gnomes Blackrock\ Mountain The\ Grand\ Tournament The\ League\ of\ Explorers Whispers\ of\ the\ Old\ Gods) }
    validates :formats, inclusion: { in: %w(standard free) }

    scope :of_format, -> (format) { where formats: format }

    def free_format?
        self.formats == 'free'
    end
end
