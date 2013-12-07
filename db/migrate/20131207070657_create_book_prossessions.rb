class CreateBookProssessions < ActiveRecord::Migration
  def change
    create_table :book_prossessions do |t|
      t.integer :book_id
      t.integer :donor
      t.integer :owner
      
      t.timestamps
    end
  end
end
