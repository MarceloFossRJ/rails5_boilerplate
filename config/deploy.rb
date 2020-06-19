# config valid for current version and patch releases of Capistrano
lock "~> 3.12.1"

set :application, ENV["APPLICATION_NAME"]
set :user, "foss"
set :repo_url, "git@bitbucket.org:marcelofossrj/journeyctrl.git"
set :pty,             true
set :use_sudo,        false
set :deploy_via,      :copy #:remote_cache

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/#{fetch(:branch)}`
        puts "WARNING: HEAD is not the same as origin/#{fetch(:branch)}"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc "sync files to final path"
  task :sync do
    on roles(:app) do
      begin
        execute "rm -R #{fetch(:final_path)}"
      rescue
        execute "echo rm failed"
      end
      execute "cp -LR #{release_path} #{fetch(:final_path)}"
    end
  end

  desc "Retrieve app version and revision"
  task :set_version do
    on roles(:app) do
      revision = `SHA1=$(git rev-parse --short HEAD 2> /dev/null); if [ $SHA1 ]; then echo $SHA1; else echo 'unknown'; fi`.chomp
      version = `VERSION=$(git describe --tags 2> /dev/null); if [ $VERSION ]; then echo $VERSION; else echo 'unknown'; fi`.chomp
      version = version.gsub(";","")
      revision = revision.gsub(";","")
      begin
        execute "cd #{fetch(:final_path)} && rm journeyctrl_version.yml"
        puts "%%%===>>> Set_version: JourneyCtrl v#{version} :: rev#{revision}"
        execute "echo 'version: #{version}' > #{fetch(:final_path)}/journeyctrl_version.yml"
        execute "echo 'revision: #{revision}' >> #{fetch(:final_path)}/journeyctrl_version.yml"

      rescue
        execute "cd #{fetch(:final_path)} && echo -e 'ERROR retrieving app version date=#{Time.now.utc}'"
      end
    end
  end
end

