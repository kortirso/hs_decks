class UserMailer < ApplicationMailer
    def welcome_email(user)
        @user = user
        mail(to: @user.email, subject: 'Welcome to HearthStone Deck Builder project')
    end

    def news_email(news, user)
        @news = news
        @user = user
        mail(to: @user.email, subject: 'News from HearthStone Deck Builder project')
    end
end
