class InvitationPolicy < ApplicationPolicy
  attr_reader :user, :invitation

  def initialize(user, invitation)
    @user = user
    @invitation = invitation
    @current_workspace = current_workspace
  end

  def create?
    @user.is_admin?(@current_workspace)
  end

  def index?
    @user.is_admin?(@current_workspace)
  end


  def resend_invitation?
    @user.is_admin?(@current_workspace)
  end

  def remove_invitation?
    @user.is_admin?(@current_workspace)
  end

end

