class UserFilter
  attr_reader :status

  def initialize(status)
    @status = status
  end

  def to_string
    status || "Everyone"
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
