class StudentApplicationFormsController < ApplicationController
  before_action :fetch_active_student
  before_action :ensure_active_student


  def new
    @email = @student.email
  end

  def create
    p = params[:student]
    @student.update_attributes!(first_name: p[:first_name])
    redirect_to students_path
  end

  private
  def allow_only_email_verified_students
    # if application already filled, can't update.
    unless @student.status_email_verified?
      flash[:info] = "Please login to visit that page"
      redirect_to root_path
    end
  end

end
