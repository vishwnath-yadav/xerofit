class CreateWorkouts < ActiveRecord::Migration
  def change
    create_table :workouts do |t|
      t.string :name
      t.string :subtitle
      t.string :description
      t.string :state, default: Workout::STATES.first
      t.integer :user_id
      t.timestamps
    end
  end
end
