class StudentIdRemove < ActiveRecord::Migration[5.2]
  def change
    remove_column :offers, :student_id
  end
end
