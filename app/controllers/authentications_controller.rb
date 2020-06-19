class AuthenticationsController < ApplicationController

  def all
    begin
      @user = User.from_omni_auth(auth_data, session[:user_subdomain])
      if @user.persisted?
        flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: "#{auth_data.provider}"
        sign_in_and_redirect @user, event: :authentication
      else
        data = auth_data.except('extra') # Removing extra as it can overflow some session stores
        session['devise.oauth.data'] = data# So data will be available after this request when creating the user
        msg = @user.errors.full_messages.join("\n")
        redirect_to new_user_registration_url, alert: msg
      end
    rescue StandardError => e
      redirect_to new_user_registration_url, alert: e.message
    end
  end

  alias_method :github, :all
  alias_method :linkedin, :all
  alias_method :google_oauth2, :all

  def validate_subdomain
    subdomain = params[:subdomain]
    # respond to /authentications/validate_subdomain/:subdomain
    is_valid, er = Workspace.validate_subdomain(subdomain)
    if is_valid
      session[:user_subdomain] = subdomain
    else
      session[:user_subdomain] = ""
    end
    e = er[0] || ""
    respond_to do |format|
      format.json { render json: {"is_valid": is_valid, "errors": 'Subdomain ' + e } }
    end
  end

  private

  def auth_data
    request.env['omniauth.auth']
  end
end
