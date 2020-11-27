class StudentEvaluationsController < ApplicationController
  before_action :fetch_active_student
  before_action :ensure_active_student
  before_action :allow_only_task_submitted_or_later_students

  def show

  end

  def allow_only_task_submitted_or_later_students
    # if application already filled, can't update. can only do
    # the subsequent steps
    ok = @student.status_task_submitted? || @student.status_task_reviewed?
    unless ok
      flash[:info] = "Please submit the task before checking results"
      redirect_to root_path
    end
  end
end
