class Collection < ApplicationRecord
    has_many :cards, dependent: :destroy
    
    validates :name, presence: true, inclusion: { in: %w(Basic Classic Promo Reward Naxxramas Goblins\ vs\ Gnomes Blackrock\ Mountain The\ Grand\ Tournament The\ League\ of\ Explorers Whispers\ of\ the\ Old\ Gods) }
    validates :formats, presence: true, inclusion: { in: %w(standard free) }

    def free_format?
        self.formats == 'free'
    end
end
