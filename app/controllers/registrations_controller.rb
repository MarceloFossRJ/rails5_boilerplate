class RegistrationsController < Devise::RegistrationsController
  layout "site", only: [:new, :create]

  def new
    build_resource
    yield resource if block_given?
    @invitation_token = params[:invitation_token] # pulls the value from the url query string
    respond_with resource
  end

  def create
    build_resource(sign_up_params)
    sign_up_params[:invitation_token] = params[:invitation_token]
    resource.create_with_transaction(sign_up_params)

    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      # respond_with resource
      render :new, layout: "site"
    end
  end

  private

  def after_sign_up_path_for(resource)
    confirmation_sent_url
  end

  def after_update_path_for(resource)
    dashboard_path
  end

end