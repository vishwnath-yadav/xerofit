class AddNumberOfMovesToWorkouts < ActiveRecord::Migration
  def change
  	add_column :workouts, :number_of_moves, :integer, default: 0
  end
end
