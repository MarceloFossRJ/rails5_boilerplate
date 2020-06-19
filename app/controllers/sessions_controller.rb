class SessionsController < Devise::SessionsController
  layout "site"

  protected

  def after_sign_in_path_for(resource)
    #logger.debug ">>> SESSIONS CONTROLLER: #{dashboard_url(subdomain: resource.default_workspace)}"
    dashboard_url(subdomain: resource.default_workspace )
  end

  def after_sign_out_path_for(resource)
    homepage_url(subdomain: nil)
  end
end