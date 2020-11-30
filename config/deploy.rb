lock "~> 3.14.1"

# this should be the same as in the ansible provisioning repo
deploy_app_name = "merkid"

# always use the current local branch to deploy, since we're precompiling assets from local box
# and rsyncing it to the server.
current_branch = `git branch`.match(/\* (\S+)\s/m)[1]
set :branch, current_branch

set :application, deploy_app_name
set :repo_url, "git@github.com:jasim/merkid.git"
set :deploy_to, "/home/deploy/#{deploy_app_name}"

append :linked_files, "config/database.yml", "config/master.key"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

set :keep_releases, 5

set :nginx_use_ssl, true
set :puma_init_active_record, true
set :migration_role, :app

set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip

# use the custom google cloud ssh access key which terraform configures servers with
# set :ssh_options, {:keys => ["#{ENV['HOME']}/.ssh/gcloud_id_rsa"]}
# we're now using DigitalOcean and so standard ssh keys (jasim, sherin) are copied.

def clear_task(t)
  Rake::Task[t].clear if Rake::Task.task_defined?(t)
end

clear_task 'deploy:assets:precompile'

# https://sourcey.com/articles/precompiling-assets-for-large-rails-deployments-with-capistrano
# http://archive.is/bwykD
namespace :deploy do
  namespace :assets do
    desc "Precompile assets locally and then rsync to deploy server"
    task :precompile do
      assets = fetch(:assets_prefix)
      packs = fetch(:packs_dir)
      run_locally do
        execute "RAILS_ENV=production bundle exec rake assets:precompile"
      end
      on roles(:app) do |host|
        hostname = host.hostname
        user = host.user
        run_locally do
          cmd_string = "rsync -av ./public/#{assets}/ #{user}@#{hostname}:#{release_path}/public/#{assets}/"
          execute cmd_string

          cmd_string = "rsync -av ./public/packs/ #{user}@#{hostname}:#{release_path}/public/packs/"
          execute cmd_string
        end

        within(release_path) do
          yarn_install = "NODE_ENV=production yarn install --no-progress --no-audit --frozen-lockfile --production --no-optional"
          execute "cd #{release_path} && #{yarn_install}"
        end
      end

      run_locally do
        execute "rm -rf public/#{assets}"
        execute "rm -rf public/packs"
      end
    end
  end
end

namespace :deploy do
  # restart the node server as well
  after :finished, 'pm2:restart'
end
