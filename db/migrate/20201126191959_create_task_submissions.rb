class CreateTaskSubmissions < ActiveRecord::Migration[6.0]
  def change
    create_table :task_submissions, id: :uuid do |t|
      t.uuid :user_id
      t.timestamps
    end
  end
end
