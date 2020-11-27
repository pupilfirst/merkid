class AddFormFieldsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :college, :text
    add_column :users, :portfolio, :text
    add_column :users, :anything_else, :text
  end
end
