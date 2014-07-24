class AddTypeToLibraries < ActiveRecord::Migration
  def change
    add_column :libraries, :move_type, :string, :default => "Single Move"
  end
end
