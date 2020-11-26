class HomeController < ApplicationController
  before_action :fetch_active_student
  before_action :show_if_active_student

  def show
  end
end
