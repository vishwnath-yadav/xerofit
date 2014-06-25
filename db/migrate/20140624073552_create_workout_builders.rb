class CreateWorkoutBuilders < ActiveRecord::Migration
  def change
    create_table :workout_builders do |t|
      t.string :name
      t.string :subtitle
      t.string :description
      t.integer :user_id

      t.timestamps
    end
  end
end
