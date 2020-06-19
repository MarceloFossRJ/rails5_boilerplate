class ErrorsController < ApplicationController
  layout "error"

  def not_found
    begin
      @exception = request.env["action_dispatch.exception"]
      @message = @exception.message.to_s
      @date = Time.now.utc.to_s
    ensure
      render status: 404, template: "errors/not_found.html.erb"
    end
  end

  def server_error
    begin
      @exception = request.env["action_dispatch.exception"]
      exception_wrapper = ActionDispatch::ExceptionWrapper.new(request.env['action_dispatch.backtrace_cleaner'], @exception)

      @message = @exception.message.to_s
      @source_extracts = exception_wrapper.source_extracts[0..9].join("\n")
      @backtrace = @exception.backtrace[0..9].join("/n")
      @date = Time.now.utc.to_s
      @file = exception_wrapper.file
      @line_number = exception_wrapper.line_number

      if ENV['AMBIENTE'] != 'development'
        mail = ErrorMailer.server_error(@date, @message, @file, @line_number, @backtrace, @source_extracts)
        mail.deliver_later
      end
    ensure
      render status: 500, template: "errors/server_error.html.erb"
    end
  end

end
