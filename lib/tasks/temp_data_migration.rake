namespace 'temp_data_migration' do
  desc "Fill-in data for new column - task_submitted_at (17-Dec-2020)"
  task fill_task_submitted_at: :environment do
    users = User.kept.where(status: User::TASK_SUBMITTED, task_submitted_at: nil)
    puts "Total #{users.count} users who have status `task_submitted`, but with its date empty."
    users.each.with_index do |user, i|
      submission = user.task_submissions.first
      puts "#{i} #{user.email}"
      if submission
        user.update_attributes!(task_submitted_at: submission.created_at)
      else
        puts "^ Error: no submission, even though status is 'task_submitted'"
      end
    end
  end
end
