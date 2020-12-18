class CreateReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews, id: :uuid do |t|
      t.uuid :user_id
      t.text :private_notes
      t.integer :tests_passing
      t.integer :clean_code
      t.integer :program_design
      t.integer :language_selection
      t.integer :portfolio_quality
      t.integer :holistic_evaluation
      t.timestamps
    end
  end
end
