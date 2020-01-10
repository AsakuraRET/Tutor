class ActiveColumn < ActiveRecord::Migration[5.2]
  def change
    add_column :help_requests, :active, :boolean, default: true 
  end
end
