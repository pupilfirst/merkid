class TasksController < ApplicationController
  before_action :fetch_active_student
  before_action :ensure_active_student

  # ask whether to reveal the task
  def new
    unless @student.status_application_form_submitted?
      flash[:error] = "Invalid step"
      redirect_to root_path
      return
    end
  end

  # reveal the task
  def create
    @student.reveal_task!
    flash[:info] = "Congratulations, you have revealed the programming task. Read on!"
    redirect_to edit_students_task_path
  end

  # task zip file upload form
  def edit
    # this is if we're hosting the course in a different domain altogether..
    # like "irvrnt.com" being the static site and fullstack.irvrnt.com being the rails web app.
    # and the zip is stored in the static site.
    @root_website_hostname = request.protocol + request.domain.sub("fullstack.", "")
    # for dev environment
    if request.port
      @root_website_hostname = @root_website_hostname + ":#{request.port}"
    end
    unless @student.status_task_revealed?
      flash[:error] = "Invalid step"
      redirect_to root_path
      return
    end
  end

  # upload the zip file and move to next step
  def update
    unless @student.status_task_revealed?
      flash[:error] = "Invalid step - you have either already submitted your code, or you've not revealed the task yet."
      redirect_to root_path
      return
    end

    file = params[:solution_zip_file]

    unless file
      flash[:error] = ["You must upload a ZIP file to submit"]
      redirect_to edit_students_task_path
      return
    end

    unless file.content_type.in?(%w(zip application/zip application/x-zip application/x-zip-compressed))
      flash[:error] = ["You must upload a ZIP file to submit"]
      redirect_to edit_students_task_path
      return
    end

    flash[:success] = ["You have successfully uploaded your code submission."]
    @student.submit_task_file!(params[:solution_zip_file])
    redirect_to root_path
  end

  def javascript
    resolve_task_url("javascript")
  end

  def java
    resolve_task_url("java")
  end

  def python
    resolve_task_url("python")
  end

  def ruby
    resolve_task_url("ruby")
  end

  def cpp
    resolve_task_url("cpp")
  end

  def c
    resolve_task_url("c")
  end

  private

  def resolve_task_url(language)
    redirect_to "https://github.com/nseadlc-2020/package-todo-cli-task/blob/release/_build/fellowship-#{language}.zip?raw=true"
  end
end
