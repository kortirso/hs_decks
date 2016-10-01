class NewsletterJob < ApplicationJob
    queue_as :default

    def perform(news)
        User.news_subscribers.each do |user|
            UserMailer.news_email(news, user).deliver_later
        end
    end
end
