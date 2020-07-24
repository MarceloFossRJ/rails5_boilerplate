
#Template Name: Kickstart application template
#Author: Andy Leverenz
#Author URI: https://web-crunch.com
#Instructions: $ rails new myapp -d <postgresql, mysql, sqlite> -m template.rb

def source_paths
  [File.expand_path(File.dirname(__FILE__))]
end

def add_gems
  gem 'figaro'
  gem 'jquery-rails'
  gem 'rubocop', require: false
  gem 'inline_svg', '~> 1.7'
  gem 'bootstrap', '~> 4.5.0'
  gem 'momentjs-rails' # for date-range-picker
  gem 'bootstrap-daterangepicker-rails' # date-range-picker booking.com style
  gem "select2-rails"
  gem "simple_form"
  gem "paper_trail", '~> 10.3.0'
  gem "ransack"
  gem "kaminari"
  gem "country_select"
  gem 'carrierwave'
  gem 'mini_magick'
  gem 'money-rails'
  gem 'apartment'
  gem 'daemons'
  gem 'devise'
  gem 'devise-async' # send emails via sidekiq
  gem 'omniauth', '~> 1.9.1'
  gem 'omniauth-google-oauth2', '~> 0.8.0'
  gem 'omniauth-linkedin-oauth2'
  gem 'omniauth-github', '~> 1.4.0'
  gem 'pwned' # implements pawned (hacked) passwords check
  gem 'pundit' # user authorization
  gem 'gravatar_image_tag', github: 'mdeering/gravatar_image_tag'
  gem 'scenic'
  gem 'prawn' #print to pdf
  gem 'prawn-table'
  gem 'rubyzip', '~> 2.3.0'
  gem 'axlsx', '~> 1.3.6'
  gem 'caxlsx_rails', '~> 0.6.2'
  gem 'sidekiq', '~> 6.0.6'
  gem 'sidekiq-cron', '~> 1.1'
  gem 'redis'
  gem 'hiredis'
  
  gem_group :development, :test do
    gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
    gem 'better_errors', github: 'BetterErrors/better_errors'
    gem "binding_of_caller"
    gem 'guard'
    gem 'guard-livereload'
    gem "rspec-rails"
    gem "factory_bot_rails"
    gem "shoulda"
    gem "faker"
    gem 'minitest-reporters'
    gem 'rails-controller-testing'
    gem "database_cleaner"
  end

  gem_group :test do
    gem 'capybara', '>= 2.15'
    gem 'selenium-webdriver'
    gem 'chromedriver-helper'
    gem 'simplecov', require: false
    gem "launchy"
  end
  
  gem_group :developement do
    gem 'web-console', '>= 3.3.0'
    gem 'listen', '>= 3.0.5', '< 3.2'
    gem 'spring'
    gem 'spring-watcher-listen', '~> 2.0.0'
    gem 'spring-commands-rspec'
    gem "capistrano", "~> 3.11", require: false
    gem "capistrano-rails", "~> 1.4", require: false
    gem 'capistrano-rvm',     require: false
    gem 'capistrano-bundler', require: false
    gem 'capistrano3-puma',   require: false
    gem 'capistrano-locally', require: false
  end
end

def set_application_name
  # Ask user for application name
  application_name = ask("Input application name. Default: f055")

  # Checks if application name is empty and add default Jumpstart.
  application_name = application_name.present? ? application_name : "f055"

  # Add Application Name to Config
  environment "config.application_name = '#{application_name}'"

  # Announce the user where he can change the application name in the future.
  puts "Application name is #{application_name}. You can change this later on: ./config/application.rb"
end

def remove_app_css
  # Remove Application CSS
  run "rm app/assets/stylesheets/application.css"
end

def remove_error_pages
  run "rm public/404.html"
  run "rm public/422.html"
  run "rm public/500.html"
end

def copy_lib
  directory "lib", force: true
end

def copy_app
  directory "app", force: true
end

def copy_vendor
  directory "vendor", force: true
end

def copy_migrations
  directory "db", force: true
end

def copy_public
  directory "public", force: true
end

def copy_config
  directory "config", force: true
end

# Main setup
add_gems

after_bundle do
  remove_app_css
  remove_error_pages

  copy_app
  copy_vendor
  copy_migrations
  copy_public
  copy_config
  copy_lib
  copy_file "Capfile"
  copy_file "git_version.sh"
  copy_file "git_version.yml"
  copy_file ".rvmrc"
  copy_file ".rspec"
  copy_file ".gitignore"
  
  insert_into_file '.gitignore', after: "breakman.html" do <<-CODE
    
    # Ignore application configuration
    /config/application.yml
    CODE
  end
  
  set_application_name
  
  # Migrate
  #rails_command "db:create"
  #rails_command "db:migrate"

  git :init
  git add: "."
  git commit: %Q{ -m "Initial commit" }
end
