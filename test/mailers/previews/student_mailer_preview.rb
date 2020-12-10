class StudentMailerPreview < ActionMailer::Preview
  def login_link
    StudentMailer.with(student: User.first).login_link
  end

  def begin_application
    StudentMailer.with(student: User.first).begin_application
  end
end