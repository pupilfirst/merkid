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
end
