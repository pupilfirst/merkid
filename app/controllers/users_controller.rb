class UsersController < ApplicationController
  def first_step
    email = params[:email]
    user = User.find_by(email: email)
    if user
      # If already db, redirect to send_login (tell that hey check email. send email in background)
      redirect_to student_send_login_email_path
    else
      # If not, redirect_to place where they see the damn form and can submit and can get added to system
      redirect_to new_student_path(email: email)
    end
  end
end
