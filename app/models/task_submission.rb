class TaskSubmission < ApplicationRecord
  has_one_attached :uploaded_file
  belongs_to :user
end
