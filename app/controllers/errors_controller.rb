class ErrorsController < ApplicationController
  before_action :set_status

  def not_found
    respond_to do |format|
      format.html { render status: 404 }
      format.json { render json: { error: "Resource not found" }, status: 404 }
    end
  end

  def unacceptable
    respond_to do |format|
      format.html { render status: 422 }
      format.json { render json: { error: "Params unacceptable" }, status: 422 }
    end
  end

  def internal_error
    respond_to do |format|
      format.html { render status: 500 }
      format.json { render json: { error: "Internal server error" }, status: 500 }
    end
  end

  private

  def set_status
      @exception = env['action_dispatch.exception']
      @status    = ActionDispatch::ExceptionWrapper.new(env, @exception).status_code
      @response  = ActionDispatch::ExceptionWrapper.rescue_responses[@exception.class.name]
  end


end