class AddColumnenable < ActiveRecord::Migration
  def change
  	add_column :moves, :enable, :boolean, default: true
  	add_column :workouts, :enable, :boolean, default: true
  	add_column :full_workouts, :enable, :boolean, default: true
  end
end
