class AddSortIndexToBlocks < ActiveRecord::Migration
  def change
    add_column :blocks, :sort_index, :integer
  end
end
