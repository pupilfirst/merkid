class AddMainProgramExtensionToTaskSubmissions < ActiveRecord::Migration[6.0]
  def change
    add_column :task_submissions, :extname, :string
  end
end
