require 'pp'
require 'zip'

class ExpandSubmissionAutogradeService
  CORRECT_FILENAMES = ["todo.py", "todo.c", "todo.java", "todo.cpp", "todo.rb", "todo.js"]

  attr_reader :student, :submission, :stats

  def initialize(student, stats)
    @student = student
    @submission = student.task_submissions.last
    @stats = stats
  end

  def run!
    # We only deal with submissions that are pending review.
    return false unless student.status == User::TASK_SUBMITTED

    # Already extracted, don't do nothing. It should've been autograded when extracted if invalid.
    # So it is a valid submission - we should manually review.
    return if submission.main_program_text.present?

    ActiveRecord::Base.transaction do
      main_program_contents = unzip_and_save_main_program
      autograde_invalid_submission(main_program_contents)
    end
  end

  def unzip_and_save_main_program
    zip_contents = submission.uploaded_file.download
    begin
      Zip::File.open_buffer(zip_contents) do |zip|
        return unzip_and_save(zip, submission)
      end
    rescue Zip::Error
      return
    end
  end

  def autograde_invalid_submission(contents)
    is_valid = contents.present? && contents.length > 300

    if is_valid
      puts "Maybe valid - main program present > 300 -- #{Rails.application.routes.url_helpers.review_student_url(id: student.id, host: "apply.pupilfirst.org", protocol: "https")} -- #{student.display_name}"
      stats[:maybe_valid] = stats[:maybe_valid] + 1
    else
      if contents.present?
        puts "Invalid (main program present < 300) -- #{Rails.application.routes.url_helpers.review_student_url(id: student.id, host: "apply.pupilfirst.org", protocol: "https")} -- #{student.display_name}"
        stats[:invalid_program_too_short] = stats[:invalid_program_too_short] + 1
      else
        puts "Invalid (no main program) -- #{Rails.application.routes.url_helpers.review_student_url(id: student.id, host: "apply.pupilfirst.org", protocol: "https")} -- #{student.display_name}"
        stats[:invalid_program_absent] = stats[:invalid_program_absent] + 1
      end

      if ENV['EXECUTE_LIVE'] == 'yes'
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
  end

  private

  def unzip_and_save(zip, submission)
    main_file = zip.find do |entry|
      filename = File.basename(entry.name).downcase
      entry.file? && CORRECT_FILENAMES.include?(filename)
    end

    # NO MAIN PROGRAM FOUND
    return unless main_file

    filename = File.basename(main_file.name).downcase
    extname = File.extname(filename).downcase
    extname = extname[1..-1] if extname[0] == '.'

    contents = main_file.size > 20_000 ? "File too large" : main_file.get_input_stream.read

    stats[:extracted_program] = stats[:extracted_program] + 1

    if ENV['EXECUTE_LIVE'] == 'yes'
      submission.update_attributes!(
        main_program_text: contents,
        main_program_extname: extname
      )
    end

    return contents
  end
end
