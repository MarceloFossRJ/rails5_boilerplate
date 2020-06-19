class ConfirmationsController < Devise::ConfirmationsController

  private
  def after_confirmation_path_for(resource_name, resource)
    # automatic log in the user
    sign_in(resource)

    # send welcome email
    mail = WelcomeMailer.welcome_on_board(resource)
    mail.deliver_later

    # go to welcome page
    welcome_url(subdomain: resource.subdomain)
  end
end