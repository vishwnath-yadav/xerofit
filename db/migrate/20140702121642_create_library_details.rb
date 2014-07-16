class CreateLibraryDetails < ActiveRecord::Migration
  def change
    create_table :library_details do |t|
      t.boolean :repetition, default: true
      t.boolean :weight, default: true
      t.boolean :distance, default: true
      t.boolean :is_duration, default: true
      t.integer :minute, default: 0
      t.integer :second, default: 0
      t.boolean :is_tempo, default: true
      t.integer :temp_lower, default: 1
      t.integer :temp_pause, default: 1
      t.integer :temp_lift, default: 1
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
