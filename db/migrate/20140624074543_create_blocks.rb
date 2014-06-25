class CreateBlocks < ActiveRecord::Migration
  def change
    create_table :blocks do |t|
      t.string :name
      t.string :subtitle
      t.integer :workout_id

      t.timestamps
    end
  end
end
