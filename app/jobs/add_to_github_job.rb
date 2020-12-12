class AddToGithubJob < ApplicationJob
  queue_as :default

  def perform(file, student)
    AddToGithubService.new(file, student).execute
  end
end