Rails.application.routes.draw do
  # https://github.com/mperham/sidekiq/wiki/Monitoring
  # TODO: allow only for admins
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root to: 'home#show'

  post 'first_step', to: "users#first_step"

  # FIXME: this should be a POST otherwise F5 refresh will keep sending emails
  #  get 'student/send_login_email', to: "students#send_login_email"
  # get 'student/application_form', to: "students#application_form", as: :student_application_form

  resource :students, only: [:new, :show, :create] do
    get :login_email_sent
  end

=begin
  get 'student/reveal_task', to: "students#reveal_task", as: :student_reveal_task
  get 'student/solution', to: "student_solutions#show", as: :student_solution
  post 'student/solution', to: "student_solutions#submit"
=end
end
