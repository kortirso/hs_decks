class UserMailer < ApplicationMailer
    def welcome_email(user)
        @user = user
        mail(to: @user.email, subject: 'Welcome to Deck Hunter project')
    end

    def news_email(news, user)
        @news = news
        @user = user
        mail(to: @user.email, subject: 'News from Deck Hunter project')
    end

    def upload_collection(result, user, username)
        @result = result
        @user = user
        @username = username
        mail(to: @user.email, subject: 'Uploading card collection at Deck Hunter project')
    end
end
