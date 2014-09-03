class RemoveColumns < ActiveRecord::Migration
  def change
  	remove_column :moves, :mark_complete
    remove_column :workouts, :mark_complete
    remove_column :moves, :is_full_workout
  end
end
