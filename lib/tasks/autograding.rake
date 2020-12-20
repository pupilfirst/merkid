# https://trello.com/c/BDTr3Euh/88-add-autograding-for-empty-invalid-submissions
namespace 'autograding' do
  desc "Grade invalid submissions automatically"
  task grade_invalid_submissions: :environment do
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
      puts student.display_name
      is_invalid = AutogradeService.new(student).is_invalid_submission?
      puts is_invalid ? "** INVALID **" : "(valid)"
      puts "\n\n\n"
      is_invalid
    }

    invalid_submissions.each { |student|
      url = Rails.application.routes.url_helpers.review_student_url(id: student.id, host: "apply.pupilfirst.org", protocol: "https")
      puts "#{url} #{student.display_name}"
    }

    puts ""
    puts "Total task submissions pending: #{User.kept.where(status: User::TASK_SUBMITTED).count}"
    puts "Short subjective answers count (< 50 letters total): #{short_subjective_answers_count}"
    puts ""
    puts "Probing zip files for empty/invalid submissions, based on LIMIT: #{to_check.count}"
    puts "Invalid submissions due to not having valid file present: #{invalid_submissions.count}"
    puts ""
    puts ""
  end
end
