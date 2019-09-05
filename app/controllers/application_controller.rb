class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :redirect_to_subdomain

  layout "application"

  private

  def redirect_to_subdomain
    if request.subdomain.blank?
      redirect_to root_url(subdomain: 'www')
    end
    if !self.is_a?(DeviseController)
      if current_user.present? && request.subdomain != current_user.subdomain
        redirect_to dashboard_url(subdomain: current_user.subdomain)
      end
    end
  end

  # redirect somewhere that will eventually return back to here
  def redirect_away(*params)
    session[:original_uri] = request.request_uri
    redirect_to(*params)
  end

  # returns the person to either the original url from a redirect_away or to a default url
  def redirect_back(*params)
    uri = session[:original_uri]
    session[:original_uri] = nil
    if uri
      redirect_to uri
    else
      redirect_to(*params)
    end
  end


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password, :subdomain, :country, :mobile_phone, :zipcode, :password_confirmation)}
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :email, :password, :current_password, :subdomain, :country, :mobile_phone, :zipcode)}
  end
end
