class News < ApplicationRecord
    validates :url_label, :label, :caption, :image, presence: true
end
