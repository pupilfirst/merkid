class User < ApplicationRecord
  EMAIL_UNVERIFIED = "email_unverified"
  EMAIL_VERIFIED = "email_verified"
  APPLICATION_FORM_SUBMITTED = "application_form_submitted"

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

  # workflow operations
  def mark_verified!
    update_attributes!(status: EMAIL_VERIFIED) if status_email_unverified?
  end

  def submit_application_form!(h)
    update_attributes!(status: APPLICATION_FORM_SUBMITTED, first_name: h[:first_name])
  end

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
