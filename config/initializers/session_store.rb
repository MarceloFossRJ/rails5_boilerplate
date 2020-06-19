if Rails.env.development?
  Rails.application.config.session_store :redis_store, key: "_#{ENV["APPLICATION_NAME"]}_development_session", domain: ".#{ENV["DOMAIN_NAME"]}"
elsif Rails.env.test?
  Rails.application.config.session_store :redis_store, key: "_#{ENV["APPLICATION_NAME"]}_test_session", domain: ".#{ENV["DOMAIN_NAME"]}"
elsif Rails.env.production?
  Rails.application.config.session_store :redis_store, key: "_#{ENV["APPLICATION_NAME"]}_session", domain: ".#{ENV["DOMAIN_NAME"]}"
end

