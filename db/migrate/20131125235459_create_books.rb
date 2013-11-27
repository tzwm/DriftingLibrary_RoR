class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.string :subtitle
      t.string :author
      t.string :author_infor
      t.string :image
      t.string :summary
      t.string :publisher
      t.string :pubdate
      t.integer :num
      t.string :isbn
      t.string :url

      t.timestamps
    end
  end
end
