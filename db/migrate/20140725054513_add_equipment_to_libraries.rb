class AddEquipmentToLibraries < ActiveRecord::Migration
  def change
    add_column :libraries, :equipment, :string, array: true, default: []
  end
end
