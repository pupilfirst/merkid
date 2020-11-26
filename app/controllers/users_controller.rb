class UsersController < ApplicationController
  def first_step
    email = params[:email]
    student = User.find_by(email: email)
    if student
      # If already db, redirect to send_login (tell that hey check email. send email in background)
      UserMailer.with(student: student).login_email.deliver_later
      redirect_to login_email_sent_students_path
    else
      # If not, redirect_to place where they see the damn form and can submit and can get added to system
      redirect_to new_student_path(email: email)
    end
  end
end
