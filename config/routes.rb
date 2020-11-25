Rails.application.routes.draw do
  # https://github.com/mperham/sidekiq/wiki/Monitoring
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
