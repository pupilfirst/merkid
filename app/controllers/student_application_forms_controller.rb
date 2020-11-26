class StudentApplicationFormsController < ApplicationController
  before_action :fetch_active_student
  before_action :ensure_active_student
end
