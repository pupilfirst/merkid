class Review::DashboardController < ReviewController
  def index
    @filter = UserFilter.new(params[:status])
    students = @filter.filtered.order("updated_at DESC")
    @filtered_count = students.count
    @students = students.page(params[:page]).per(200)
  end

  def student
    @student = User.find(params[:id])
    @review = @student.review || @student.build_review
  end

  def begin_review
    next_student = User.next_student_for_review
    if next_student.count == 1
      student = next_student.first
      redirect_to review_student_path(id: student.id)
    else
      flash[:info] = "No more students left to review!"
      redirect_to review_path
    end
  end

  def save_review
    r = params[:review]
    @student = User.find(params[:id])
    @review = @student.review || @student.build_review

    @review.tests_passing = r[:tests_passing]
    @review.clean_code = r[:clean_code]
    @review.program_design = r[:program_design]
    @review.language_selection = r[:language_selection]
    @review.portfolio_quality = r[:portfolio_quality]
    @review.holistic_evaluation = r[:holistic_evaluation]
    @review.private_notes = r[:private_notes]
    if @review.save
      @student.mark_task_reviewed!
      flash.clear
      redirect_to review_begin_review_path
    else
      flash[:error] = @review.errors.map { |attr, msg| "#{attr} #{msg}" }
      render :'review/dashboard/student'
    end
  end
end
