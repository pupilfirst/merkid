class UserFilter
  attr_reader :status

  def initialize(status)
    @status = status
  end

  def to_string
    unless status
      return "Everyone"
    end
    if status == User::TASK_SUBMITTED
      "Pending Review"
    else
      status
    end
  end

  def active?
    @status.present?
  end

  def filtered
    users = User.kept
    if active?
      if status == User::TASK_SUBMITTED
        users.where(status: status)
             .order("task_submitted_at asc")
      else
        users.where(status: status)
      end
    else
      users
    end
  end
end
