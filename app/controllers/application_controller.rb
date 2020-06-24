class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :redirect_to_subdomain
  before_action :set_user_session
  helper_method :current_workspace
  helper_method :my_workspaces
  layout "application"
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def current_workspace
    session[:current_workspace]
  end

  def my_workspaces
    session[:my_workspaces]
  end

  def create_redirect_path(action)
    if action == 'add'
      url_for controller: controller_name, action: 'new'
    else
      url_for controller: controller_name, action: 'index'
    end
  end

  def link_away(name, options = {}, html_options = nil)
    link_to(name, { :return_uri => url_for(:only_path => true) }.update(options.symbolize_keys), html_options)
  end

  #-----------------------
  private

  def after_sign_out_path_for(resource)
    root_url(:host => request.domain)
  end

  # apartment:
  def redirect_to_subdomain
    if request.subdomain == 'www'
      redirect_to root_url(subdomain: '')
    end

    if !self.is_a?(DeviseController)
      subdomain = request.subdomain
      # if user has sign in sucessfully and is an member of the selected workspace, he can access it
      if user_signed_in?
        if subdomain.to_s.length == 0
          workspaces = Workspace.by_member(current_user.id).pluck(:subdomain)
          if workspaces.nil?
            sign_out current_user
          else
            session[:my_workspaces] = workspaces
            session[:current_workspace] = Workspace.find_by_subdomain(current_user.default_workspace) ||
                                          Workspace.find_by_subdomain(workspaces[0])
            redirect_to dashboard_url(subdomain: session[:current_workspace].subdomain)
          end
        else
          if (session[:current_workspace].nil?) || (session[:current_workspace].blank?)
            workspaces = Workspace.by_member(current_user.id).pluck(:subdomain)
            # check if user is a member of the referred workspace
            if workspaces
              session[:my_workspaces] = workspaces
              session[:current_workspace] = Workspace.find_by_subdomain(subdomain)
              if session[:my_workspaces].include? subdomain
                redirect_to dashboard_url(subdomain: subdomain)
              else
                flash[:alert] = "You are not authorized to login to this workspace."
                redirect_to homepage_url
              end
            else
              flash[:alert] = "You are not authorized to login to this workspace."
              redirect_to homepage_url
            end
          end
          if subdomain != session[:current_workspace].nil? ? "0" : session[:current_workspace].subdomain
            workspaces = Workspace.by_member(current_user.id).pluck(:subdomain)
            # check if user is a member of the referred workspace
            if workspaces
              session[:my_workspaces] = workspaces
              session[:current_workspace] = Workspace.find_by_subdomain(subdomain)
              redirect_to dashboard_url(subdomain: subdomain) unless session[:my_workspaces].include? subdomain
            else
              flash[:alert] = "You are not authorized to login to this workspace."
              redirect_to dashboard_url(subdomain: session[:current_workspace].subdomain)
            end
          end
        end
      end

      # if there is no current logged user and there is a subdomain go to homepage
      sub = request.subdomain
      if !current_user.present? && sub.to_s.length > 0
        redirect_to root_url(subdomain: '')
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

  #-----------------------
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password, :subdomain, :password_confirmation, :invitation_token)}
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :email, :password, :avatar, :avatar_cache, :remove_avatar, :current_password, :subdomain, :password_confirmation)}
  end

  def general_error(title, msg)
    flash.now[:error] = msg
    render status: 405, template: "errors/general_error.html.erb", locals: {title: title}
  end

  def set_attachment_name(name)
    escaped = URI.encode(name)
    response.headers['Content-Disposition'] = "attachment; filename*=UTF-8''#{escaped}"
  end

  private

# handles storing return links in the session
  def link_return
    if params[:return_uri]
      session[:original_uri] = params[:return_uri]
    end
  end

  # make session available through the app
  def set_user_session
    UserSession.current_user = session[:current_user]
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end
end
