class RemoveviewsCountToMove < ActiveRecord::Migration
  def change
  	remove_column :moves, :views_count
  end
end
