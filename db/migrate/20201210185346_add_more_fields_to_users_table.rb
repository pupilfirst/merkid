class AddMoreFieldsToUsersTable < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :state, :string
    add_column :users, :phone_number, :string
    add_column :users, :semester, :string
    add_column :users, :course, :string
  end
end
