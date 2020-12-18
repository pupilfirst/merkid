namespace 'email_students' do
  desc "Notify students that we received their submission"
  task submission_received: :environment do

    if ENV['TEST_EMAIL']
      users = [User.find_by(email: 'jasim@protoship.io')]
      total_remaining = 1
    else
      # let's be cautious and email in small batches
      limit = ENV['LIMIT']
      if limit
        limit = limit.to_i
      else
        puts "Pass in LIMIT argument to set email batch size. Defaulting to 10"
        limit = 10
      end

      users = User.kept.where(
        status: [User::TASK_SUBMITTED, User::TASK_REVIEWED],
        submission_receipt_emailed_at: nil
      )
      total_remaining = users.count
      puts "Total #{total_remaining} users who have submitted, but yet to be emailed receipt of their code submission."

      users = users.limit(limit)
    end

    users.each.with_index do |user, i|
      puts "#{i} -- #{user.display_name} -- #{user.email}"
      StudentMailer.with(student: user).code_submission_received.deliver_later
      user.update_attributes!(submission_receipt_emailed_at: DateTime.now)
    end

    # (must re-run the rake task until everyone is emailed)
    puts "Emailed #{users.length} students. Remaining #{total_remaining - users.length} to be emailed"
  end
end
