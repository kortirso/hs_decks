class News < ApplicationRecord
    validates :url_label, :label, :caption, :image, presence: true

    after_create :news_notify

    private

    def news_notify
        NewsletterJob.perform_later(self)
    end
end
