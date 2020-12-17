class AddSubmissionReceiptEmailedAtToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :submission_receipt_emailed_at, :datetime
  end
end
