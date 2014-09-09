class RenameHistroysTable < ActiveRecord::Migration
  def change
    rename_table :histroys, :histories
  end
end
