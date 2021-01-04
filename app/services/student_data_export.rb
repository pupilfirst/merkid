class StudentDataExport
  attr_reader :students

  def initialize(students)
    @students = students
  end

  def to_csv
    attributes = %w[full_name REVIEW_LINK email task_reviewed_at first_name college portfolio anything_else]
    attributes = attributes.concat(
      %w[state phone_number semester course source]
    )
    attributes = attributes.concat(
      %w[task-main_program_extname]
    )
    attributes = attributes.concat(
      %w[r-tests_passing r-clean_code r-program_design r-language_selection r-portfolio_quality r-holistic_evaluation]
    )
    attributes = attributes.concat(
      %w[TOTAL_SCORE]
    )

    CSV.generate(headers: true) do |csv|
      csv << attributes

      students.each do |student|
        cols = []
        task = student.task_submissions.last
        review = student.review
        attributes.each do |attr|
          if attr.upcase == attr
            # custom column, call the instance method directly
            cols.push(send(attr.underscore, student, task, review))
          elsif attr.starts_with?("task-")
            a = attr.sub("task-", "")
            cols.push(task.send(a))
          elsif attr.starts_with?("r-")
            a = attr.sub("r-", "")
            cols.push(review.send(a))
          else
            if attr == "task_reviewed_at"
              d = student.task_reviewed_at.in_time_zone('Asia/Kolkata')
              cols.push(d)
            else
              cols.push(student.send(attr))
            end
          end
        end
        csv << cols
      end
    end
  end

  # CUSTOM COLUMNS
  def review_link(student, _task, _review)
    Rails.application.routes.url_helpers.review_student_url(id: student.id, host: "apply.pupilfirst.org", protocol: "https")
  end

  def total_score(_student, _task, review)
    r = review
    r.tests_passing + r.clean_code + r.program_design + r.language_selection +
      r.portfolio_quality + r.holistic_evaluation
  end
end
