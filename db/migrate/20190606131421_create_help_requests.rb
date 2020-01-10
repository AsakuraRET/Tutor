class CreateHelpRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :help_requests do |t|
      t.string :description
      t.integer :subject_id
      t.float :price
      t.integer :user_id

      t.timestamps
    end
  end
end
