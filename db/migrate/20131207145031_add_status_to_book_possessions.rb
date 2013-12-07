class AddStatusToBookPossessions < ActiveRecord::Migration
  def change
    add_column :book_possessions, :status, :string
  end
end
