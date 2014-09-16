class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
    	t.string :status
	    t.integer :move_id
	    t.integer :workout_id
      t.timestamps
    end
  end
end
