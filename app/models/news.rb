class News < ApplicationRecord
    validates :url_label, :label, :caption, :image, presence: true

    after_create :news_notify

    private

    def news_notify
        User.news_subscribers.each do |user|
             UserMailer.news_email(self, user).deliver
        end
        #NewsletterJob.perform_later(self)
    end
end
