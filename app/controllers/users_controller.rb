class UsersController < ApplicationController
  def first_step
    email = params[:email].downcase
    student = User.find_by(email: email)
    if student
      # Already in the system, send a login link
      flash[:info] = "Check your email for the login link!"
      StudentMailer.with(student: student).login_link.deliver_later
      render "students/login_email_sent"
    elsif CheckDeadlineService.new.disabled
      flash[:error] = "The admissions for the current batch of Coronasafe Engineering Fellowship is currently closed."
      redirect_to root_path
    else
      # First time applicant! Make an entry, and send a email verify mail
      student = User.new(email: email.downcase, status: User::EMAIL_UNVERIFIED)
      if student.save
        StudentMailer.with(student: student).begin_application.deliver_later
        flash[:info] = "Check your email for the login link!"
        render "students/email_verify_and_start_application"
      else
        flash[:error] = "Invalid email id #{params[:email]}"
        redirect_to root_path
      end
    end
  end

  def logout
    session[:active_student_id] = nil
    flash[:info] = "You have been logged out successfully."
    redirect_to "/"
  end
end
