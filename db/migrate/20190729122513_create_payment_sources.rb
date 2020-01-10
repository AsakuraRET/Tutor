class CreatePaymentSources < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_sources do |t|
      t.string :last_4
      t.string :cvc
      t.string :exp_year
      t.string :exp_month
      t.integer :student_id

      t.timestamps
    end
  end
end
