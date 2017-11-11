# User Mailer Preview
class UserMailerPreview < ActionMailer::Preview
    def sample_mail_preview
        UserMailer.welcome_email(User.first)
    end

    def sample_news_mail_preview
        UserMailer.news_email(News.first, User.first)
    end
end
