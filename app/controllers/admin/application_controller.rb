# All Administrate controllers inherit from this
# `Administrate::ApplicationController`, making it the ideal place to put
# authentication logic or other before_actions.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    before_action :ensure_admin

    def ensure_admin
      user = User.find_by(id: session[:active_student_id])

      if user.blank?
        flash[:error] = "Please login to visit that page"
        redirect_to root_path
        return
      end

      return if user.is_admin?

      flash[:error] = "You have to be an admin to access this page"
      redirect_to root_path
    end

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end
  end
end
