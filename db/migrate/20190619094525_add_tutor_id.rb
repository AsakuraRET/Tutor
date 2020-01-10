class AddTutorId < ActiveRecord::Migration[5.2]
  def change
    add_column :help_requests, :tutor_id, :integer
  end
end
