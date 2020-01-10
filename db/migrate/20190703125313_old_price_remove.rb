class OldPriceRemove < ActiveRecord::Migration[5.2]
  def change
    remove_column :offers, :old_price
  end
end
