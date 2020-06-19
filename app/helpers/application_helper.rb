module ApplicationHelper

  # Flash messages with Bootstrap
  def flash_class(level)
    case level
      when "notice" then "alert alert-info"
      when "success" then "alert alert-success"
      when "error" then "alert alert-danger"
      when "alert" then "alert alert-danger"
    end
  end

  # used to redirect a page when changing the workspace
  def workspace_redirect_domain
    if ['production', 'staging'].include? ENV["AMBIENTE"]
      port = ""
    else
      port = ":4000"
    end
    ENV["DOMAIN_NAME"] + port + "/dashboard"
  end

  def roles_select(selected_role, id)
    html = "<select name='role' id ='role' class='form-control form-control-sm' data='#{id}'>"
    Member.roles.each do |k,v|
      html << "<option value='#{k.to_s}'"
      html << " selected" if k.to_s == selected_role
      html << ">#{v}</option>"
    end
    html << "</select>"
  end
end
