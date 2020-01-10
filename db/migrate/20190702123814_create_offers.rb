class CreateOffers < ActiveRecord::Migration[5.2]
  def change
    create_table :offers do |t|
      t.integer :student_id
      t.float :old_price
      t.float :new_price
      t.integer :help_request_id
      t.integer :tutor_id

      t.timestamps
    end
  end
end
