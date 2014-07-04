class CreateLibraryDetails < ActiveRecord::Migration
  def change
    create_table :library_details do |t|
      t.boolean :repetition
      t.boolean :weight
      t.boolean :distance
      t.string :time
      t.string :duration
      t.string :temp_lower
      t.string :temp_pause
      t.string :temp_lift
      t.integer :library_block_id

      t.timestamps
    end
  end
end
