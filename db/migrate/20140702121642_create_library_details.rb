class CreateLibraryDetails < ActiveRecord::Migration
  def change
    create_table :library_details do |t|
      t.boolean :repetitions, default: true
      t.boolean :weight, default: true
      t.boolean :distance, default: true
      t.string  :dist_option 
      t.integer :dist_val, default: 1
      t.integer :weight_val, default: 1
      t.boolean :duration, default: true
      t.integer :minute, default: 0
      t.integer :second, default: 0
      t.boolean :tempo, default: true
      t.integer :temp_lower, default: 0
      t.integer :temp_pause, default: 0
      t.integer :temp_lift, default: 0
      t.integer :rep_min, default: 1
      t.integer :rep_max, default: 1
      t.integer :rep_total, default: 1
      t.boolean :rep_each_side, default: true
      t.string :rep_option
      t.integer :library_block_id
      t.timestamps
    end
  end
end
