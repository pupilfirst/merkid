class StudentsController < ApplicationController
  before_action :fetch_active_student
  before_action :show_if_active_student, only: [:new, :create]

  def new
    @email = params[:email]
  end

  def create
    p = params[:student]
    student = User.create!(email: p[:email], first_name: p[:first_name])
    session[:active_student_id] = student.id
    redirect_to students_path
  end

  def show
    redirect_to root_path unless @student
  end

  def login_email_sent

  end
end
