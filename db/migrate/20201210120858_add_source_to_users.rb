class AddSourceToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :source, :text
  end
end
