class CreatePendingBooks < ActiveRecord::Migration
  def change
    create_table :pending_books do |t|
      t.integer :book_possession_id
      t.integer :sender_id
      t.integer :receiver_id
      t.string :status

      t.timestamps
    end
  end
end
