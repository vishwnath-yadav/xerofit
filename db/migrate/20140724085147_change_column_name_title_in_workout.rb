class ChangeColumnNameTitleInWorkout < ActiveRecord::Migration
  def change
  	rename_column :workouts, :name, :title
  end
end
