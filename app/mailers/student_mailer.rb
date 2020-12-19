class StudentMailer < ApplicationMailer
  default to: -> { params[:student].email }

  def login_link
    @student = params[:student]
    @url = login_with_token_students_url(token: @student.id)
    simple_roadie_mail(subject: 'Login link for CoronaSafe Engineering Fellowship application')
  end

  def begin_application
    @student = params[:student]
    @url = login_with_token_students_url(token: @student.id)
    simple_roadie_mail(subject: 'Begin your CoronaSafe Engineering Fellowship application!')
  end

  def code_submission_received
    @student = params[:student]
    mail(to: @student.email,
         subject: "We've received your code submission!") do |format|
      format.html { render layout: 'plain_email_layout' }
    end
  end

  def application_completion_reminder
    @student = params[:student]
    mail(to: @student.email,
         subject: "CoronaSafe Engineering Fellowship: Complete your application soon!") do |format|
      format.html { render layout: 'plain_email_layout' }
    end
  end
end
