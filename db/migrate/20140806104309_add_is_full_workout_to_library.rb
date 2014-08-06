class AddIsFullWorkoutToLibrary < ActiveRecord::Migration
  def change
    add_column :libraries, :is_full_workout, :boolean, default: false
  end
end
