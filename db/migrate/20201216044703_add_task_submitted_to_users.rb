class AddTaskSubmittedToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :task_submitted_at, :datetime
    add_column :users, :task_reviewed_at, :datetime
    add_column :users, :task_review_message, :string
  end
end
