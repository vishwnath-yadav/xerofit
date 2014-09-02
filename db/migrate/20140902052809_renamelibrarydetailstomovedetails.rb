class Renamelibrarydetailstomovedetails < ActiveRecord::Migration
  def change
  	rename_table :library_details, :move_details
  	rename_table :library_blocks, :move_blocks
  end
end
