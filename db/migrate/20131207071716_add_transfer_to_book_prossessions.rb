class AddTransferToBookProssessions < ActiveRecord::Migration
  def change
    add_column :book_prossessions, :transfer_count, :integer
  end
end
