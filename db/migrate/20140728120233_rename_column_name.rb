class RenameColumnName < ActiveRecord::Migration
  def change
  	rename_column :target_muscle_groups, :target_type, :sub_target_muscle_group
  end
end
