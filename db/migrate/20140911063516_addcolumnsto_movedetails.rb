class AddcolumnstoMovedetails < ActiveRecord::Migration
  def change
  	remove_column :move_details, :weight_val
  	add_column :move_details, :sets, :boolean, default: false
  	add_column :move_details, :sets_count, :integer, default: 1 
  	add_column :move_details, :rest, :boolean, default: false
  	add_column :move_details, :rest_time, :integer, default: 30
  end
end
