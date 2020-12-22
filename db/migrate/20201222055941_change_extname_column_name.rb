class ChangeExtnameColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :task_submissions, :extname, :main_program_extname
  end
end
