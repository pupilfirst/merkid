class AddTermsAgreedAtToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :terms_agreed_at, :datetime
  end
end
