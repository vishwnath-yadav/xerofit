class CreateMarketplaceLists < ActiveRecord::Migration
  def change
    create_table :marketplace_lists do |t|
      t.string :title
      t.boolean :status, default: true
      t.integer :order
      t.timestamps
    end
  end
end
