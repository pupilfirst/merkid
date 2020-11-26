class StudentApplicationFormsController < ApplicationController
  before_action :fetch_active_student
  before_action :ensure_active_student
  before_action :allow_only_email_verified_students

  def new
    @email = @student.email
  end

  def create
    p = params[:student]
    @student.submit_application_form!(first_name: p[:first_name])
    redirect_to students_path
  end

  private

  def allow_only_email_verified_students
    # if application already filled, can't update. can only do
    # the subsequent steps
    unless @student.status_email_verified?
      flash[:info] = "Application is already filled"
      redirect_to root_path
    end
  end

end
