class AddViewsCountToMoves < ActiveRecord::Migration
  def change
  	add_column :moves, :views_count, :integer, default: 0
  end
end
