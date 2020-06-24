Sidekiq::Extensions.enable_delay!

Sidekiq.configure_server do |config|
  config.redis = { url: ENV["JOB_URL"] } # ENV["JOB_URL"]
  #schedule_file = "config/schedule.yml"
  #if File.exists?(schedule_file)
  #  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
  #end
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV["JOB_URL"]  }
end