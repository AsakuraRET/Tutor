class CreateChats < ActiveRecord::Migration[5.2]
  def change
    create_table :chats do |t|
      t.integer :message_id
      t.integer :student_id
      t.integer :tutor_id

      t.timestamps
    end
  end
end
