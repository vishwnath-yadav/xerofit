class AddTypeToLibraries < ActiveRecord::Migration
  def change
    add_column :libraries, :move_type, :string
  end
end
