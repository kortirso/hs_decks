# Welcome Mailer Job
class WelcomeletterJob < ApplicationJob
    queue_as :default

    def perform(user)
        UserMailer.welcome_email(user).deliver
    end
end
