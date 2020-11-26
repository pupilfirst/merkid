class StudentsController < ApplicationController
  before_action :fetch_active_student
  before_action :show_if_active_student, only: [:new, :create]

  def create
    p = params[:student]
    student = User.create!(email: p[:email], first_name: p[:first_name])
    session[:active_student_id] = student.id
    redirect_to students_path
  end

  def show
    redirect_to root_path unless @student
  end

  def login_with_token
    p = params[:token]
    student = User.find_by(id: p)
    if student
      session[:active_student_id] = student.id
      student.mark_verified!
      redirect_to root_path
    else
      render plain: "Invalid login"
    end
  end
end
