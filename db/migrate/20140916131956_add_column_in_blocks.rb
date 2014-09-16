class AddColumnInBlocks < ActiveRecord::Migration
  def change
  	add_column :blocks, :minutes, :integer, default: 0
  	add_column :blocks, :seconds, :integer, default: 0
  end
end
