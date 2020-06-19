class ErrorMailer < ApplicationMailer
  def not_found(date, message)
    mail(   to:       ENV['SUPPORT_EMAIL'],
            subject:  "Application Name - #{ENV['AMBIENTE']} [404]"
    ) do |format|
      @date = date
      @message = message
      #format.text
      format.html
    end
  end

  def server_error(date, message, file, line_number, backtrace, souce_extracts)
    mail(   to:       ENV['SUPPORT_EMAIL'],
            subject:  "Application Name - #{ENV['AMBIENTE']} [500]"
    ) do |format|
      @date = date
      @message = message
      @file = file
      @line_number = line_number
      @backtrace = backtrace
      @souce_extracts = souce_extracts

      format.html
    end
  end
end
# TODO REPLACE APPLICATION NAME