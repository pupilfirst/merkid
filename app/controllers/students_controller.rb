class StudentsController < ApplicationController
  def new
    @email = params[:email]
  end

  def create
    p = params[:student]
    student = User.create!(email: p[:email], first_name: p[:first_name])
    redirect_to student_path(id: student.id)
  end

  def show
    render plain: User.find(params[:id])
  end
end
