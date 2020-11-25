class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :first_name
      t.string :full_name
      t.string :email
      t.date :dob
      t.string :tf_token
      t.jsonb :tf_data
      t.string :status

      t.timestamps
    end
  end
end
