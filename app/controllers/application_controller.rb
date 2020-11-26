class ApplicationController < ActionController::Base
  def fetch_active_student
    @student ||= User.find_by(id: session[:active_student_id])
  end

  def show_if_active_student
    redirect_to students_path if @student
  end
end
