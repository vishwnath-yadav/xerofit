class FixColumnName < ActiveRecord::Migration
  def change
  	rename_column :target_muscle_groups, :library_id, :move_id
  	rename_column :library_videos, :library_id, :move_id
  	rename_column :library_blocks, :library_id, :move_id
  	rename_column :users, :fullname, :first_name
  	add_column :users, :last_name, :string

  end
end
