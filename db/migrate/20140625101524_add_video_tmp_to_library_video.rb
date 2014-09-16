class AddVideoTmpToLibraryVideo < ActiveRecord::Migration
  def change
    add_column :library_videos, :video_tmp, :string
  end
end
