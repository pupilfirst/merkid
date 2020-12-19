class AddCompletionReminderEmailedAtToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :completion_reminder_emailed_at, :datetime
  end
end
