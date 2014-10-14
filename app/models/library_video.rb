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
    self.panda_video.encodings['h264'] rescue ''
  end

  def panda_mp4_url
    self.panda_video.encodings['h264'].url rescue ''
  end

  def panda_mp4_hd_url
    self.panda_video.encodings['h264.1080p'].url rescue ''
  end

  def panda_ogg_url
    self.panda_video.encodings['ogg'].url rescue ''
  end

  def panda_ogg_hd_url
    self.panda_video.encodings['ogg.720p'].url rescue ''
  end

  def panda_thumbnail
    self.panda_video.encodings['thumbnail'] rescue []
  end

  def panda_thumbnail_hd_url
    self.panda_video.encodings['thumbnail.HD'].url rescue ''
  end

  def video_title
	 self.panda_video.original_filename rescue ''
  end

  def video_image
   self.image rescue '/assets/ex_2.png'
  end

end