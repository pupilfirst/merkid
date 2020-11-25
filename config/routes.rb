Rails.application.routes.draw do
  # https://github.com/mperham/sidekiq/wiki/Monitoring
  # TODO: allow only for admins
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  get 'student', to: "students#show"
  get 'student/start_application', to: "students#start_application"
  get 'student/reveal_task', to: "students#reveal_task", as: :student_reveal_task

  get 'student/solution', to: "student_solutions#show", as: :student_solution
  post 'student/solution', to: "student_solutions#submit"
end
