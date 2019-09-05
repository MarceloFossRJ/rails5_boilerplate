class LogFormatter < ActiveSupport::Logger::SimpleFormatter

  def call(severity, time, progname, msg)
    formatted_severity = sprintf("%-5s",severity.to_s)
    formatted_time = time.strftime("%Y-%m-%d %H:%M:%S")
    "[#{formatted_time}, #{formatted_severity}]: #{msg} from #{progname}\n"
  end
end
