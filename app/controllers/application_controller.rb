class ApplicationController < ActionController::Base
  before_action :set_raven_context

  def fetch_active_student
    @student ||= User.find_by(id: session[:active_student_id])
  end

  def show_if_active_student
    redirect_to students_path if @student
  end

  def ensure_active_student
    unless @student
      flash[:error] = "Please login to visit that page"
      redirect_to root_path
    end
  end

  private

  def set_raven_context
    Raven.user_context(id: session[:active_student_id])
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
