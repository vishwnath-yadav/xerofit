class AddStatusToLibrary < ActiveRecord::Migration
  def change
    add_column :libraries, :status, :string
  end
end
