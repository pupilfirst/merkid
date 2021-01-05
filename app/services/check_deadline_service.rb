class CheckDeadlineService
  def disabled
    deadline = DateTime.parse('2021-01-05').in_time_zone('Asia/Kolkata').end_of_day
    Time.now.in_time_zone('Asia/Kolkata') > deadline
  end
end
