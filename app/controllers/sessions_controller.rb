class SessionsController < Devise::SessionsController
  protected

  def after_sign_in_path_for(resource)
    dashboard_path(subdomain: resource.subdomain)
  end

  def after_sign_out_path_for(resource_name)
    root_path(subdomain: 'www')
  end
end