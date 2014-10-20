class AddColumnInMarketplaceMoves < ActiveRecord::Migration
  def change
  	drop_table :statastics
  	add_column :marketplace_moves, :moves_order, :integer
  end
end
