class AddStatusIndexToUsers < ActiveRecord::Migration[6.0]
  def change
    add_index :users, :status
  end
end
