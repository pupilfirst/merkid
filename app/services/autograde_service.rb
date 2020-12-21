# .size bytes or what?

require 'pp'
require 'zip'

class AutogradeService
  CORRECT_FILENAMES = ["todo.py", "todo.c", "todo.java", "todo.cpp", "todo.rb", "todo.js"]

  attr_reader :student

  def initialize(student)
    @student = student
  end

  def is_invalid_submission?
    return unless student.status == User::TASK_SUBMITTED

    submission = student.task_submissions.last
    return unless submission

    zip_contents = submission.uploaded_file.download
    begin
      Zip::File.open_buffer(zip_contents) do |zip|
        return !can_have_submission?(zip)
      end
    rescue Zip::Error
      puts "Non-zip file uploaded by #{Rails.application.routes.url_helpers.review_student_url(id: student.id, host: "apply.pupilfirst.org", protocol: "https")}\n"
      true
    end
  end

  def can_have_submission?(zip)
    zip.each do |entry|
      next unless entry.file?

      filename = File.basename(entry.name).downcase
      return entry.size > 300 if CORRECT_FILENAMES.include?(filename)
    end
    false
  end

  def mark_as_invalid_submission!
    review = student.build_review
    review.tests_passing = 0
    review.clean_code = 0
    review.program_design = 0
    review.language_selection = 0
    review.portfolio_quality = 0
    review.holistic_evaluation = 0
    review.private_notes = "Invalid submission (auto-graded)."
    review.save!
    student.mark_task_reviewed!
  end
end
