class Review::DashboardController < ReviewController
  def index
    @filter = UserFilter.new(params[:status])
    students = @filter.filtered.order("updated_at DESC")
    @filtered_count = students.count
    @students = students.page(params[:page]).per(50)
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

  def save_quick_review
    @student = User.find(params[:id])
    @review = @student.review || @student.build_review

    if params[:unrelated_submission] || params[:empty_submission] || params[:plagiarized_dp]
      @review.tests_passing = 0
      @review.clean_code = 0
      @review.program_design = 0
      @review.language_selection = 0
      @review.portfolio_quality = 0
      @review.holistic_evaluation = 0
      if params[:unrelated_submission]
        @review.private_notes = "Unrelated submission."
      elsif params[:empty_submission]
        @review.private_notes = "Empty submission."
      elsif params[:plagiarized_dp]
        @review.private_notes = "Dhruv Panchal."
      end
    elsif params[:unqualified]
      @review.tests_passing = 0
      @review.clean_code = 0
      @review.program_design = 0
      @review.language_selection = 0
      @review.portfolio_quality = 0
      @review.holistic_evaluation = 0
      @review.private_notes = "Quick review - Unqualified."
    elsif params[:at_par]
      language = @student.task_submissions.last.main_program_extname
      if %w[py js rb].include?(language)
        @review.language_selection = 1
      else
        @review.language_selection = 0
      end
      @review.tests_passing = 0
      @review.clean_code = 1
      @review.program_design = 1
      @review.portfolio_quality = 0
      @review.holistic_evaluation = 1
      @review.private_notes = "Quick review - At Par."
    else
      flash[:error] = "Invalid quick review type"
      redirect_to review_begin_review_path
      return
    end

    if @review.save
      @student.mark_task_reviewed!
      flash.clear
      flash[:info] = "Marked previous review as #{@review.private_notes}"
      redirect_to review_begin_review_path
    else
      flash[:error] = @review.errors.map { |attr, msg| "#{attr} #{msg}" }
      render :'review/dashboard/student'
    end
  end
end
