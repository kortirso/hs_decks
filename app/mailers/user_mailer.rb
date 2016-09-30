class UserMailer < ApplicationMailer
    def welcome_email(user)
        @user = user
        @url = 'http://46.101.217.59:3005'
        mail(to: @user.email, subject: 'Welcome to HearthStone Deck Builder project')
    end
end
