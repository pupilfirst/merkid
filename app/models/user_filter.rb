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
      users.where(status: status)
    else
      users
    end
  end
end
