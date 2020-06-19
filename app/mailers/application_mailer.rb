class ApplicationMailer < ActionMailer::Base
  default from: ENV['SENDMAIL_DEVISE']
  layout 'mailer'
end
