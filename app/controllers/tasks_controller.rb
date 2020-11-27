class TasksController < ApplicationController
  before_action :fetch_active_student
  before_action :ensure_active_student

  # ask whether to reveal the task
  def new
    unless @student.status_application_form_submitted?
      flash[:info] = "Invalid step"
      redirect_to root_path
    end
  end

  # reveal the task
  def create
    @student.reveal_task!
    redirect_to students_path
  end

  # task zip file upload form
  def edit
    unless @student.status_task_revealed?
      flash[:info] = "Invalid step"
      redirect_to root_path
    end
  end

  # upload the zip file and move to next step
  def update
    unless @student.status_task_revealed?
      flash[:info] = "Invalid step"
      redirect_to root_path
    end

    @student.submit_task_file!(params[:solution_zip_file])

    redirect_to root_path
  end

  private
end
