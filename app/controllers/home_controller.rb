class HomeController < ApplicationController
  before_action :fetch_active_student
  before_action :show_if_active_student, except: %w[terms stats]

  def show
  end

  def terms
    redirect_to "https://drive.google.com/file/d/1qQ0VugHXozra2qc_95wXNLcFC4rmIJEp/view"
  end

  def stats
  end
end
