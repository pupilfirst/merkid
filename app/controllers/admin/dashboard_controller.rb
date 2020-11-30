class Admin::DashboardController < AdminController
  def index
    @filter = UserFilter.new(params[:status])
    @students = @filter.filtered
  end

  def student
    @student = User.find(params[:id])
  end
end
