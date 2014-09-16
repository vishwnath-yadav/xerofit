class Changecolumnname < ActiveRecord::Migration
  def change
  	rename_column :move_details, :library_block_id, :move_block_id
  end
end
