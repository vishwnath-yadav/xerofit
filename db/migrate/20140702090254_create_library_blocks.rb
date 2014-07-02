class CreateLibraryBlocks < ActiveRecord::Migration
  def change
    create_table :library_blocks do |t|
      t.references :block, :null => false
  	  t.references :library, :null => false
      t.timestamps
    end
  end
end
