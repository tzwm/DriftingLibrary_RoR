class AddIndexesToAllTables < ActiveRecord::Migration
  def change
    add_index :books, :isbn
    add_index :books, :title

    add_index :wishes, :user_id
    add_index :wishes, :book_id

    add_index :borroweds, :user_id
    add_index :borroweds, :book_id

    add_index :book_possessions, :book_id
    add_index :book_possessions, :donor
    add_index :book_possessions, :holder
    add_index :book_possessions, :status

    add_index :pending_books, :book_possession_id
    add_index :pending_books, :sender_id
    add_index :pending_books, :receiver_id
    add_index :pending_books, :status

    add_index :donateds, :user_id
    add_index :donateds, :book_id
  end
end
