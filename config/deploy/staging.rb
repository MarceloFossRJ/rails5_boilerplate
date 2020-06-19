
server 'ethanol.f055.com', roles: [:web, :app, :db], primary: true

set :branch,          "master"
set :stage,           :staging
set :deploy_to,       "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :keep_releases, 2
set :final_path,      "#{fetch(:deploy_to)}/#{fetch(:application)}"

append :linked_files, 'staging.env'

namespace :deploy do
  desc 'stop application'
  task :stop do
    on roles(:app), in: :sequence, wait: 5 do
      execute "cd #{release_path} && docker-compose -f docker-compose.yml -f docker-compose.stg.yml stop"
    end
  end

  desc "Copy env files"
  task :copy_env do
    run_locally do
      execute "rsync -ah --progress /Users/foss/Dropbox/dev/ruby/f055/jouneyctrl/journeyctrl/staging.env #{fetch(:user)}@ethanol.f055.com:#{fetch(:deploy_to)}/shared"
    end
  end

  desc 'Build Docker-compose'
  task :build do
    on roles(:app) do
      execute "cd #{fetch(:final_path)} && mv staging.env .env && chmod +x ./entrypoint.sh && docker-compose -f docker-compose.yml -f docker-compose.stg.yml build"
    end
  end

  desc 'Run Docker-compose'
  task :start do
    on roles(:app) do
      execute "cd #{fetch(:final_path)} && docker-compose -f docker-compose.yml -f docker-compose.stg.yml up"
    end
  end

  before :starting,     :check_revision
  #before :starting,     :stop
  before :starting,     :copy_env
  after :publishing, 'deploy:sync'
  after :publishing, 'deploy:cleanup'
  after :publishing, 'deploy:set_version'
  after :publishing, 'deploy:build'
  after :publishing, 'deploy:start'
end