class RenameOldTableToNewTable < ActiveRecord::Migration
  def change
  	 rename_table :libraries, :moves
  end
end
