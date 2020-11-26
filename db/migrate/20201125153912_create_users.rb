class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :first_name
      t.string :full_name
      t.string :email
      t.date :dob
      t.jsonb :application_form
      t.string :status
      t.datetime :task_revealed_at

      t.timestamps
    end
  end
end
