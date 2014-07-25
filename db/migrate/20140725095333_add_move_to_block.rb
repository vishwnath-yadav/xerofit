class AddMoveToBlock < ActiveRecord::Migration
  def change
    add_column :blocks, :move, :integer, default: 0
  end
end
