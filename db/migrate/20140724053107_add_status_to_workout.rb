class AddStatusToWorkout < ActiveRecord::Migration
  def change
    add_column :workouts, :status, :string
  end
end
