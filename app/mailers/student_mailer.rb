class StudentMailer < ApplicationMailer
  def login_link
    @student = params[:student]
    @url = login_with_token_students_url(token: @student.id)
    mail(to: @student.email, subject: 'Login link for CoronaSafe Engineering Fellowship application')
  end

  def begin_application
    @student = params[:student]
    @url = login_with_token_students_url(token: @student.id)
    mail(to: @student.email, subject: 'Begin your CoronaSafe Engineering Fellowship application!')
  end
end
