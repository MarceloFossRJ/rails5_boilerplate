# in the application_controller:
# private
# def user_session
#   @user_session ||= UserSession.new(session)
# end
# helper_method :user_session

module UserSession
  def current_user
    Thread.current[:user]
  end

  def self.current_user=(user)
    Thread.current[:user] = user
  end

  ################
  class Obj
    def initialize(session)
      @session = session
    end
  end
end