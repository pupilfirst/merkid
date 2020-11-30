class AdminController < ApplicationController
  before_action :fetch_active_student
  before_action :ensure_active_student
  before_action :ensure_admin

  private

  def ensure_admin
    unless @student.is_admin?
      flash[:error] = "You have to be an admin to see the reports"
      redirect_to root_path
      return
    end
    @is_admin_page = true
    @admin = @student
    @student = nil
  end
end
