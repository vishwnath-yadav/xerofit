class CreateMarketplaceMoves < ActiveRecord::Migration
  def change
    create_table :marketplace_moves do |t|
      t.references :marketplace_list, :null => false
  	  t.references :move, :null => false
      t.timestamps
    end
  end
end
