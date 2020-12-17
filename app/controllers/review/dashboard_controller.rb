class Review::DashboardController < ReviewController
  def index
    @filter = UserFilter.new(params[:status])
    students = @filter.filtered.order("updated_at DESC")
    @filtered_count = students.count
    @students = students.page(params[:page]).per(200)
  end

  def student
    @student = User.find(params[:id])
  end
end
