class AddNumToDonated < ActiveRecord::Migration
  def change
    add_column :donateds, :num, :integer
  end
end
