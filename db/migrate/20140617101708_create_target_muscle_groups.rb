class CreateTargetMuscleGroups < ActiveRecord::Migration
  def change
    create_table :target_muscle_groups do |t|
      t.integer :library_id
      t.string :target_muscle_group
      t.string :target_type

      t.timestamps
    end
  end
end
