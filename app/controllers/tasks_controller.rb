class TasksController < ApplicationController
  before_action :fetch_active_student
  before_action :ensure_active_student

  def create
    @student.reveal_task!
    redirect_to students_path
  end

  def new
  end
end
