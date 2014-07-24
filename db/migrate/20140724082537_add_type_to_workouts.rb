class AddTypeToWorkouts < ActiveRecord::Migration
  def change
    add_column :workouts, :move_type, :string, :default => "workouts"
  end
end
