Rails.application.routes.draw do
  # FIXME: restrict to admin only
  # https://github.com/mperham/sidekiq/wiki/Monitoring
  require 'sidekiq/web'
  mount Sidekiq::Web => '/admin/sidekiq'

  root to: 'home#show'

  get :terms, to: "home#terms"
  get :stats, to: "home#stats"

  get :logout, to: "users#logout"
  post 'first_step', to: "users#first_step"
  get 'first_step', to: redirect("/")

  resource :students, only: [:new, :show] do
    get :login_with_token
    resource :student_application_form, only: [:new, :show, :create] do
    end
    resource :task, only: [:new, :create, :edit, :update] do
      get 'javascript'
      get 'java'
      get 'ruby'
      get 'cpp'
      get 'python'
      get 'c'
    end
    resource :student_evaluation, only: [:show]
  end

  namespace :admin do
    get '/', to: "dashboard#index"
    get :student, to: "dashboard#student"
  end
end
