class WelcomeMailer < ApplicationMailer
  def welcome_on_board(user)
    mail(   to:       user.email,
            from:     ENV['SUPPORT_EMAIL'],
            subject:  "#{ENV['APPLICATION_NAME'].humanize} Account Activated"
    ) do |format|
      @user = user
      format.html
    end
  end
end
