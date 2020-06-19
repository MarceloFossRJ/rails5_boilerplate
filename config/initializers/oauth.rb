
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_APP_ID'], ENV['GOOGLE_SECRET'], scope: 'email,profile'

  provider :github, ENV['GITHUB_APP_ID'], ENV['GITHUB_SECRET']
  provider :linkedin, ENV['LINKEDIN_APP_ID'], ENV['LINKEDIN_SECRET'], { :scope => 'r_liteprofile r_emailaddress' }

  on_failure { |env| AuthenticationsController.action(:failure).call(env) }
end
