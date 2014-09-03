class CreateFullWorkouts < ActiveRecord::Migration
  def change
    create_table :full_workouts do |t|
      t.string :video
      t.boolean :mark_complete, default: false
      t.integer :user_id

      t.timestamps
    end
  end
end
