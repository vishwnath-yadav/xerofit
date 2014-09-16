class CreateBlocks < ActiveRecord::Migration
  def change
    create_table :blocks do |t|
      t.string :name
      t.string :subtitle
      t.string :block_type
      t.integer :workout_id

      t.timestamps
    end
  end
end
