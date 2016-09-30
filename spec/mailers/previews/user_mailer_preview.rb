class UserMailerPreview < ActionMailer::Preview
    def sample_mail_preview
        UserMailer.welcome_email(User.first)
    end
end
