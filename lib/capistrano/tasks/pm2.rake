require 'json'

# this is declared in `provisioning/roles/pm2/templates`
PM2_ECOSYSTEM_JSON_FILENAME = "pm2.config.js"

namespace :pm2 do

  def app_status
    within current_path do
      ps = JSON.parse(capture :pm2, :"--silent", :jlist, PM2_ECOSYSTEM_JSON_FILENAME)
      if ps.empty?
        return nil
      else
        # status: online, errored, stopped
        return ps[0]["pm2_env"]["status"]
      end
    end
  end

  def restart_app
    within current_path do
      ecosystem_path = Pathname.new(current_path.to_s).join("..", "shared", PM2_ECOSYSTEM_JSON_FILENAME).to_s
      execute :pm2, :stop, ecosystem_path, raise_on_non_zero_exit: false
      execute :pm2, :start, ecosystem_path, raise_on_non_zero_exit: true
    end
  end

  desc 'Restart app gracefully'
  task :restart do
    on roles(:app) do
      case app_status
      when nil
        info 'App is not registerd'
        restart_app
      when 'stopped'
        info 'App is stopped'
        restart_app
      when 'errored'
        info 'App has errored'
        restart_app
      when 'online'
        info 'App is online'
        restart_app
      end
    end
  end

end
