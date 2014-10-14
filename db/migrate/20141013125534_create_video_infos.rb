class CreateVideoInfos < ActiveRecord::Migration
  def change
    create_table :video_infos do |t|
      t.integer :completed_video_views, default: 0
      t.datetime :view_start_time
      t.datetime :view_completed_time
      t.string :status
      t.integer :move_id
      t.integer :user_id
      t.timestamps
    end
  end
end
