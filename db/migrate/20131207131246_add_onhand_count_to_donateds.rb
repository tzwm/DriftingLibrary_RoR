class AddOnhandCountToDonateds < ActiveRecord::Migration
  def change
    rename_column :donateds, :num, :donated_count
    add_column :donateds, :onhand_count, :integer
  end
end
