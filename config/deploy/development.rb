
server 'localhost', roles: [:web, :app, :db], primary: true

set :branch,          "development"
set :stage,           :development
set :deploy_to,       "/users/#{fetch(:user)}/docker/#{fetch(:application)}"
set :keep_releases,   1
set :final_path,      "#{fetch(:deploy_to)}/#{fetch(:application)}"
set :local_path, "" #Rails.root

append :linked_files, '.env'

namespace :deploy do
  desc "Copy env files"
  task :copy_env do
    run_locally do
      execute "mkdir -p #{fetch(:deploy_to)}/shared/ && cp #{fetch(:local_path)}/development.env #{fetch(:deploy_to)}/shared/.env"
    end
  end

  desc 'Build Docker-compose'
  task :build do
    on roles(:app) do
      execute "cd #{fetch(:final_path)} && docker-compose -f docker-compose.yml -f docker-compose.dev.yml build"
    end
  end

  desc 'Run Docker-compose'
  task :start do
    on roles(:app) do
      execute "cd #{fetch(:final_path)} && docker-compose -f docker-compose.yml -f docker-compose.dev.yml up"
    end
  end

  before :starting,  :check_revision
  before :starting,  :copy_env
  after :publishing, 'deploy:sync'
  after :publishing, 'deploy:cleanup'
  after :publishing, 'deploy:set_version'
  after :publishing, 'deploy:build'
  after :publishing, 'deploy:start'
end