class StudentSolutionsController < ApplicationController
  def show

  end

  def submit
    redirect_to student_path
  end
end
