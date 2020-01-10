class AddTipsIdToHelpRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :help_requests, :tips, :integer
  end
end
