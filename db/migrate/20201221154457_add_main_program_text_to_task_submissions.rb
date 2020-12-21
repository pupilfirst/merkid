class AddMainProgramTextToTaskSubmissions < ActiveRecord::Migration[6.0]
  def change
    add_column :task_submissions, :main_program_text, :text
  end
end
