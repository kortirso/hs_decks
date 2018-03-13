# Base Mailer class
class ApplicationMailer < ActionMailer::Base
  default from: 'postmaster@deckhunter.ru'
  layout 'mailer'
end
