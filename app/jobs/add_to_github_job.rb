class AddToGithubJob < ApplicationJob
  queue_as :default

  def perform(file_path, student)
    AddToGithubService.new(file_path, student).execute
  end
end