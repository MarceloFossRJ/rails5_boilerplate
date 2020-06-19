class MemberPolicy < ApplicationPolicy
  attr_reader :user, :member

  def initialize(user, member)
    @user = user
    @member = member
    @current_workspace = current_workspace
  end

  def update?
    @user.is_admin?(@current_workspace)
  end

  def index?
    @user.is_admin?(@current_workspace)
  end

  def destroy?
    @user.is_admin?(@current_workspace)
  end
end

