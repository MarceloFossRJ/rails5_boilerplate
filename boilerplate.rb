
#Template Name: Kickstart application template
#Author: Andy Leverenz
#Author URI: https://web-crunch.com
#Instructions: $ rails new myapp -d <postgresql, mysql, sqlite> -m template.rb

def source_paths
  [File.expand_path(File.dirname(__FILE__))]
end

def add_gems
  gem 'figaro'
  gem 'rubocop', require: false
  gem "simple_form"
  gem "ransack"
  gem "kaminari"
  gem "country_select"
  gem 'carrierwave'
  gem 'mini_magick'
  gem 'money-rails'
  gem 'apartment'
  gem 'devise'
  gem 'jquery-rails'
  gem 'rainbow'
  gem_group :development, :test do
    gem 'better_errors'
    gem 'guard'
    gem 'guard-livereload'
    gem "rspec-rails"
    gem "factory_bot_rails"
    gem "shoulda"
    gem "faker"
    gem 'minitest-reporters'
    gem "database_cleaner"
  end

  gem_group :test do
    gem 'capybara', '>= 2.15'
    gem 'selenium-webdriver'
    gem 'chromedriver-helper'
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

def add_users
  # Install Devise
  generate "devise:install"

  # Configure Devise
  environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }",
              env: 'development'

  route "root to: 'home#index'"
  # Create Devise User
  generate :devise, "User", "name"
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

def copy_templates
  directory "app", force: true
end

def init_guardfile
  run "guard init livereload"
end


# Main setup
add_gems

after_bundle do
  set_application_name
  add_home
  add_users
  remove_app_css
  remove_error_pages
  init_guardfile

  copy_templates

  # Migrate
  rails_command "db:create"
  rails_command "db:migrate"

  git :init
  git add: "."
  git commit: %Q{ -m "Initial commit" }
end
