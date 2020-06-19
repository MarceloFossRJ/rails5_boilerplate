class WelcomeMailer < ApplicationMailer
  def welcome_on_board(user)
    mail(   to:       user.email,
            from:     "SENDER EMAIL",
            subject:  "APPLICATION NAME Account Activated"
    ) do |format|
      @user = user
      format.html
    end
  end
end
# TODO REPLACE APPLICATION NAME
# TODO REPLACE SENDER