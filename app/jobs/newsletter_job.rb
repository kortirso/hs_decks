# Email Job
class NewsletterJob < ApplicationJob
  queue_as :default

  def perform(news)
    news_subscribers.each { |user| UserMailer.news_email(news, user).deliver }
  end

  private def news_subscribers
    User.news_subscribers
  end
end
