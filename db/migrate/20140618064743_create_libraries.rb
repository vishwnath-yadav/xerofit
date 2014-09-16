class CreateLibraries < ActiveRecord::Migration
  def change
    create_table :libraries do |t|
      t.integer :user_id
      t.string :title
      t.string :directions
      t.string :category
      t.string :difficulty
      

      t.timestamps
    end
  end
end
