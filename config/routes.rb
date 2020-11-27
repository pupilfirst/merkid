Rails.application.routes.draw do
  # https://github.com/mperham/sidekiq/wiki/Monitoring
  # TODO: allow only for admins
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root to: 'home#show'

  get :logout, to: "users#logout"
  post 'first_step', to: "users#first_step"
  get 'first_step', to: redirect("/")

  resource :students, only: [:new, :show, :create] do
    get :login_with_token
    resource :student_application_form, only: [:new, :show, :create]
    resource :task, only: [:new, :create, :edit, :update]
  end
end
