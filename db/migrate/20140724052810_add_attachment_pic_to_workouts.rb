class AddAttachmentPicToWorkouts < ActiveRecord::Migration
  def self.up
    change_table :workouts do |t|
      t.attachment :pic
    end
  end

  def self.down
    drop_attached_file :workouts, :pic
  end
end
