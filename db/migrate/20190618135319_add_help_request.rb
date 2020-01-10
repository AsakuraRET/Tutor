class AddHelpRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :help_requests, :state, :integer, default: 0
  end
end
