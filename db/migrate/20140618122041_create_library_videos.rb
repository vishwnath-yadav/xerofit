class CreateLibraryVideos < ActiveRecord::Migration
  def change
    create_table :library_videos do |t|
      t.string :panda_video_id
      t.string :video
      t.integer :library_id

      t.timestamps
    end
  end
end
