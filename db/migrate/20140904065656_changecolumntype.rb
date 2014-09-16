class Changecolumntype < ActiveRecord::Migration
  def change
  	change_column :moves, :directions, :text
  	change_column :workouts, :description, :text
  end
end
