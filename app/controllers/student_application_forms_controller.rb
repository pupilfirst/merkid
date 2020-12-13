class StudentApplicationFormsController < ApplicationController
  before_action :fetch_active_student
  before_action :ensure_active_student
  before_action :allow_only_email_verified_students

  def show
    # GET /students/student_application_form
    # Happens when page is refreshed after a failed submit (POST create)
    redirect_to new_students_student_application_form_path
  end

  def new
    @form = StudentApplicationForm.new(
      {
        email: @student.email,
        first_name: @student.first_name,
        full_name: @student.full_name,
        dob: @student.dob,
        college: @student.college,
        portfolio: @student.portfolio,
        anything_else: @student.anything_else,
        source: @student.source,
        state: @student.state,
        phone_number: @student.phone_number,
        semester: @student.semester,
        course: @student.course,
        terms_agreed: @student.terms_agreed_at.present?
      })
  end

  def create
    p = params[:form]
    attrs = {
      email: @student.email,
      first_name: p[:first_name],
      full_name: p[:full_name],
      dob: p[:dob],
      college: p[:college],
      portfolio: p[:portfolio],
      anything_else: p[:anything_else],
      source: p[:source],
      state: p[:state],
      phone_number: p[:phone_number],
      semester: p[:semester],
      course: p[:course],
      terms_agreed: p[:terms_agreed]
    }

    @form = StudentApplicationForm.new(attrs)
    @form.validate

    if @form.valid?
      attrs.delete :terms_agreed
      attrs[:terms_agreed_at] = DateTime.now

      @student.submit_application_form!(attrs)
      flash[:success] = "Thanks, your application form is now saved. Please continue to the next step."
      redirect_to students_path
    else
      flash[:error] = @form.errors.map { |attr, msg| msg }
      render :new
    end
  end

  private

  def allow_only_email_verified_students
    # if application already filled, can't update. can only do
    # the subsequent steps
    unless @student.status_email_verified?
      flash[:info] = "Application is already filled"
      redirect_to root_path
    end
  end

end
