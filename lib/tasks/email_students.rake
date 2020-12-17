namespace 'email_students' do
  desc "Notify students that we received their submission"
  task submission_received: :environment do
    users = User.kept.where(
      status: [User::TASK_SUBMITTED, User::TASK_REVIEWED],
      submission_receipt_emailed_at: nil
    )

    total_remaining = users.count
    puts "Total #{total_remaining} users who have submitted, but yet to be emailed receipt of their code submission."

    # let's be cautious and email in small batches
    users = users.to_a[0..50]

    users.each.with_index do |user, i|
      puts "#{i} -- #{user.display_name} -- #{user.email}"
      StudentMailer.with(student: user).code_submission_received.deliver_later
      user.update_attributes!(submission_receipt_emailed_at: DateTime.now)
    end

    # (must re-run the rake task until everyone is emailed)
    puts "Emailed #{users.length} students. Remaining #{total_remaining - users.length} to be emailed"
  end
end
