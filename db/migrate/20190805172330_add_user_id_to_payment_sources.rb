class AddUserIdToPaymentSources < ActiveRecord::Migration[5.2]
  def change
    add_column :payment_sources, :user_id, :integer
  end
end
