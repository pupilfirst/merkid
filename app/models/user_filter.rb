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
    if active?
      User.where(status: status)
    else
      User.all
    end
  end
end
