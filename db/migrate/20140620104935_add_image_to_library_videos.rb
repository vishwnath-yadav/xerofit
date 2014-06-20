class AddImageToLibraryVideos < ActiveRecord::Migration
  def change
    add_column :library_videos, :image, :string
  end
end
