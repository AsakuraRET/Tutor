class AddStudentId < ActiveRecord::Migration[5.2]
  def change
    rename_column :help_requests, :user_id, :student_id
  end
end
