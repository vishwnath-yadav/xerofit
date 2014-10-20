class RenameVideoInfoTable < ActiveRecord::Migration
  def change
  	rename_table :video_infos, :video_analytics
  end
end
