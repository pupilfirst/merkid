class User < ApplicationRecord
  def self.create_student!(email)
    create!(email: email.downcase, status: "email_unverified")
  end

  def status_email_unverified?
    status == "email_unverified"
  end

  def status_application_form_submitted?
    status == "application_form_submitted"
  end

  def mark_verified!
    update_attributes!(status: "email_verified") if status_email_unverified?
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
