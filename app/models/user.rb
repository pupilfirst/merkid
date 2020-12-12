class User < ApplicationRecord
  EMAIL_UNVERIFIED = 'email_unverified'.freeze
  EMAIL_VERIFIED = 'email_verified'.freeze
  APPLICATION_FORM_SUBMITTED = 'application_form_submitted'.freeze
  TASK_REVEALED = 'task_revealed'.freeze
  TASK_SUBMITTED = 'task_submitted'.freeze
  TASK_REVIEWED = 'task_reviewed'.freeze

  VALID_SOURCE = [
    'Email from College/University',
    'Facebook',
    'Friends',
    'Twitter',
    'Whatsapp',
    'Instagram',
    'Telegram',
    'Slack',
    'News Paper',
    'Facebook Developer Circle',
    'Google Developer Group',
    'Microsoft Student Partner',
    'Pupilfirst Alumni',
    'Other'
  ].freeze

  VALID_STATES = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chandigarh (UT)',
    'Chhattisgarh',
    'Dadra and Nagar Haveli (UT)',
    'Daman and Diu (UT)',
    'Delhi (NCT)',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jammu & Kashmir (UT)',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Lakshadweep (UT)',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Puducherry (UT)',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttarakhand',
    'Uttar Pradesh',
    'West Bengal'
  ].freeze

  VALID_SEMESTERS = %w[1 2 3 4 5 6 7 8 9 10 Other].freeze

  validates_format_of :email, with: /\A([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})\z/i

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
    return unless status_email_verified?
    update_attributes!(h)
    update_attributes!(status: APPLICATION_FORM_SUBMITTED)
  end

  def reveal_task!
    update_attributes!(status: TASK_REVEALED, task_revealed_at: DateTime.now) if status_application_form_submitted?
  end

  def submit_task_file!(file)
    return unless status_task_revealed?

    task_submission = task_submissions.create!
    task_submission.uploaded_file.attach(file)
    # Experimental
    AddToGithubJob.perform_later(file.path, self)
    # make filenames uniform, tag with first name so it is easy to correlate and update the correct
    # student's scores during grading
    task_submission.uploaded_file.blob.update!(filename: first_name.titleize.gsub(/\W/, '') + '-' + id[0..3] + '.zip')
    update_attributes(status: TASK_SUBMITTED)
    task_submission
  end

  # --

  def display_name
    if status_application_form_submitted?
      first_name.capitalize
    else
      email.split('@').first
    end
  end

  def more_context_name
    [first_name, email].compact.join(', ')
  end

  def is_admin?
    ['jacob@protoship.io', 'jasim@protoship.io', 'bodhish@pupilfirst.org', 'hari@pupilfirst.org', 'reena@pupilfirst.org',
      'suma@pupilfirst.org'].include?(email)
  end

  def is_coach?
    ['jacob@protoship.io', 'jasim@protoship.io', 'bodhish@pupilfirst.org', 'hari@pupilfirst.org'].include?(email)
  end
end
