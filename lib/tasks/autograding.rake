# https://trello.com/c/BDTr3Euh/88-add-autograding-for-empty-invalid-submissions
namespace 'autograding' do
  desc "Grade invalid submissions automatically"
  task grade_invalid_submissions: :environment do

    # https://stackoverflow.com/questions/20243497/rails-rake-task-on-heroku-disable-displaying-the-sql-log-on-the-screen
    # Can't see any of my "puts" in the log because of all the SQL noise
    dev_null = Logger.new("/dev/null")
    Rails.logger = dev_null
    ActiveRecord::Base.logger = dev_null

    puts "\n\n**** Begin auto-grade run at #{DateTime.now.in_time_zone('Asia/Kolkata').to_s(:short_with_dayname)}\n\n"

    # let's be cautious and work in small batches
    limit = ENV['LIMIT']
    if limit
      limit = limit.to_i
    else
      puts "Pass in LIMIT argument to set email batch size. Defaulting to 10"
      limit = 10
    end

    to_check = User.kept.where(status: User::TASK_SUBMITTED).filter { |student|
      (student.portfolio.to_s.strip + student.anything_else.to_s.strip).length < 50
    }

    short_subjective_answers_count = to_check.count

    to_check = to_check.to_a[0..limit]

    invalid_submissions = to_check.filter { |student|
      is_invalid = AutogradeService.new(student).is_invalid_submission?
      is_invalid
    }

    puts "\n\n-------- URLs for invalid submissions -------"
    invalid_submissions.each { |student|
      url = Rails.application.routes.url_helpers.review_student_url(id: student.id, host: "apply.pupilfirst.org", protocol: "https")
      puts "#{url} #{student.display_name}"
    }
    puts "---------------------------\n\n"

    puts ""
    puts "Total task submissions pending: #{User.kept.where(status: User::TASK_SUBMITTED).count}"
    puts "Short subjective answers count (< 50 letters total): #{short_subjective_answers_count}"
    puts ""
    puts "Probing zip files for empty/invalid submissions, based on LIMIT: #{to_check.count}"
    puts "Invalid submissions due to not having valid file present: #{invalid_submissions.count}"
    puts ""
    puts ""

    if ENV['EXECUTE_GRADING'].to_s.downcase == 'yes'
      puts "EXECUTE_GRADING is yes."
      puts "Marking #{invalid_submissions.count} as 'Invalid submission (auto-graded)'"
      invalid_submissions.each { |student|
        AutogradeService.new(student).mark_as_invalid_submission!
      }
      puts "Done."
    else
      puts "This was a dry run. No changes made."
    end
    puts "\n\n"
  end
end
