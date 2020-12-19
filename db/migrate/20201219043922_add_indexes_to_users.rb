class AddIndexesToUsers < ActiveRecord::Migration[6.0]
  def change
    add_index :users, :email
    add_index :users, :updated_at
  end
end
