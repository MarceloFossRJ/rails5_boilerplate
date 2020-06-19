class DashboardPolicy < Struct.new(:user, :dashboard)
  include UserSession
  attr_reader :user, :dashboard

  def initialize(user, dashboard)
    @user = user
    @dashboard = dashboard
    @current_workspace = current_workspace
  end

  def index?
    true
  end

end