class AddMarkCompleteToMove < ActiveRecord::Migration
  def change
    add_column :moves, :mark_complete, :boolean, default: false
    add_column :workouts, :mark_complete, :boolean, default: true
  end
end
