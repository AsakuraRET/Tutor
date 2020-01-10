class AddFieldStripeIdToUsersAndPaymentSourceTable < ActiveRecord::Migration[5.2]
  def change
    add_column :payment_sources, :stripe_id, :string
    add_column :users, :stripe_id, :string
  end
end
