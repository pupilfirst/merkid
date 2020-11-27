class User < ApplicationRecord
  EMAIL_UNVERIFIED = "email_unverified"
  EMAIL_VERIFIED = "email_verified"
  APPLICATION_FORM_SUBMITTED = "application_form_submitted"
  TASK_REVEALED = "task_revealed"
  TASK_SUBMITTED = "task_submitted"
  TASK_REVIEWED = "task_reviewed"

  has_many :task_submissions

  def self.create_student!(email)
    create!(email: email.downcase, status: EMAIL_UNVERIFIED)
  end

  def status_email_unverified?
    status == EMAIL_UNVERIFIED
  end

  def status_email_verified?
    status == EMAIL_VERIFIED
  end

  def status_application_form_submitted?
    status == APPLICATION_FORM_SUBMITTED
  end

  def status_task_revealed?
    status == TASK_REVEALED
  end

  def status_task_submitted?
    status == TASK_SUBMITTED
  end

  def status_task_reviewed?
    status == TASK_REVIEWED
  end
  # workflow operations
  def mark_verified!
    update_attributes!(status: EMAIL_VERIFIED) if status_email_unverified?
  end

  def submit_application_form!(h)
    update_attributes!(status: APPLICATION_FORM_SUBMITTED, first_name: h[:first_name]) if status_email_verified?
  end

  def reveal_task!
    update_attributes!(status: TASK_REVEALED, task_revealed_at: DateTime.now) if status_application_form_submitted?
  end

  def submit_task_file!(file)
    return unless status_task_revealed?
    task_submission = task_submissions.create!
    task_submission.uploaded_file.attach(file)
    update_attributes(status: TASK_SUBMITTED)
    task_submission
  end

  # --

  def display_name
    if status_application_form_submitted?
      first_name.capitalize
    else
      email
    end
  end

  def more_context_name
    [first_name, email].compact.join(", ")
  end
end
