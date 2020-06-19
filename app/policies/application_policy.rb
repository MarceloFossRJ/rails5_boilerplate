class ApplicationPolicy
  include UserSession
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
    @current_workspace = current_workspace
  end

  def index?
    @user.is_admin?(@current_workspace)
  end

  def show?
    @user.is_admin?(@current_workspace)
  end

  def create?
    @user.is_admin?(@current_workspace)
  end

  def new?
    create?
  end

  def update?
    @user.is_admin?(@current_workspace)
  end

  def edit?
    @user.is_admin?(@current_workspace)
  end

  def destroy?
    @user.is_admin?(@current_workspace)
  end

=begin
  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end
=end
end
