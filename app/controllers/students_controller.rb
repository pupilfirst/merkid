class StudentsController < ApplicationController
  before_action :fetch_active_student
  before_action :show_if_active_student, only: [:new, :create]

  def show
    redirect_to root_path unless @student
  end

  def login_with_token
    p = params[:token]
    student = User.find_by(id: p)
    if student
      session[:active_student_id] = student.id
      if student.status_email_unverified?
        flash[:success] = "Welcome to the fellowship application. Let's get started!"
        student.mark_verified!
      else
        flash[:success] = "Welcome back!"
      end
      redirect_to root_path
    else
      render plain: "Invalid login"
    end
  end
end
