class CreateBorroweds < ActiveRecord::Migration
  def change
    create_table :borroweds do |t|
      t.integer :user_id
      t.integer :book_id
	  t.integer :num

      t.timestamps
    end
  end
end
