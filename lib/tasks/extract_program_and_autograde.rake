# https://trello.com/c/BDTr3Euh/88-add-autograding-for-empty-invalid-submissions
namespace 'extract_program_and_autograde' do
  desc "Unzip and put the contents of todo.py/.c/c++/etc. into task submission"
  task unzip_and_save: :environment do

    # https://stackoverflow.com/questions/20243497/rails-rake-task-on-heroku-disable-displaying-the-sql-log-on-the-screen
    # Can't see any of my "puts" in the log because of all the SQL noise
    dev_null = Logger.new("/dev/null")
    Rails.logger = dev_null
    ActiveRecord::Base.logger = dev_null

    puts "\n\n**** Begin run at #{DateTime.now.in_time_zone('Asia/Kolkata').to_s(:short_with_dayname)}\n\n"

    # let's be cautious and work in small batches
    limit = ENV['LIMIT']
    if limit
      limit = limit.to_i
    else
      puts "Pass in LIMIT argument to set email batch size. Defaulting to 10"
      limit = 10
    end

    to_check = User.kept.joins(:task_submissions).where(
      status: User::TASK_SUBMITTED,
      "task_submissions.main_program_text": nil
    ).order("task_submitted_at asc").limit(limit).to_a

    puts ""
    puts "Unzipping and autograding the main program for students: #{to_check.length}"
    puts ""

    stats = {
      :extracted_program => 0,
      :maybe_valid => 0,
      :invalid_program_absent => 0,
      :invalid_program_too_short => 0,
    }

    to_check.each { |student|
      ExpandSubmissionAutogradeService.new(student, stats).run!
    }

    puts "\n\n"
    puts "Total submissions considered: #{to_check.length}"
    puts "  -- No main program exists and thus invalid: #{stats[:invalid_program_absent]}"
    puts "  -- Main program exists, extracted, and saved: #{stats[:extracted_program]}"
    puts "      -- Too short though: #{stats[:invalid_program_too_short]}"
    puts "      -- Long enough, could be valid: #{stats[:maybe_valid]}"
    puts "\n\nDone.\n\n"
  end
end
