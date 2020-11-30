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

append :linked_files, "config/database.yml", "config/credentials/production.key", "config/credentials/production.yml.enc"
append :linked_dirs,  "storage", "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

set :keep_releases, 5

set :nginx_use_ssl, true
set :puma_init_active_record, true
set :migration_role, :app

set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip

namespace :deploy do
  # restart the node server as well
  after :finished, 'pm2:restart'
end
