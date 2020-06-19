class WorkspacePolicy < ApplicationPolicy
  attr_reader :user, :workspace

  def initialize(user, workspace)
    @user = user
    @workspace = workspace
  end

  def index?
    true
  end

  def new?
    create?
  end

  def create?
    true
  end

  def update?
    return true if @user.is_admin?(@workspace)
    false
  end

  def edit?
    update?
  end

  def show?
    return true if @user.is_admin?(@workspace)
    false
  end

  def destroy?
    return true if @user.is_admin?(@workspace)
    false
  end

end