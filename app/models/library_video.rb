class LibraryVideo < ActiveRecord::Base
	belongs_to :move
	mount_uploader :video, VideoUploader
	# store_in_background :video

	def panda_video
		begin
		@panda_video ||= Panda::Video.find(panda_video_id)
		rescue
		@panda_video = nil
		end
	end

  def panda_mp4
    self.panda_video.encodings['h264']
  end

  def panda_mp4_hd
    self.panda_video.encodings['h264.1080p']
  end

  def panda_ogg
    self.panda_video.encodings['ogg']
  end

  def panda_ogg_hd
    self.panda_video.encodings['ogg.720p']
  end

  def panda_thumbnail
    self.panda_video.encodings['thumbnail']
  end

  def panda_thumbnail_hd
    self.panda_video.encodings['thumbnail.HD']
  end

  def video_title
	  self.panda_video.original_filename rescue ''
  end

end