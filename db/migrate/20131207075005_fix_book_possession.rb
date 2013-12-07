class FixBookPossession < ActiveRecord::Migration
  def change
    rename_table :book_prossessions, :book_possessions
    rename_column :book_possessions, :owner, :holder
  end
end
