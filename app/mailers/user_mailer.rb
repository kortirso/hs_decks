# User Mailer
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

  def upload_collection_email(args)
    @result = args[:message]
    @user = args[:user]
    @username = args[:username]
    mail(to: @user.email, subject: 'Uploading card collection at Deck Hunter project')
  end
end
