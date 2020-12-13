class HomeController < ApplicationController
  before_action :fetch_active_student
  before_action :show_if_active_student, except: [:terms]

  def show
  end

  def terms
    redirect_to "https://drive.google.com/file/d/1BfEV_oJQ4V0SrPofy5_p7GSlr4KESEgJ/view"
  end
end
