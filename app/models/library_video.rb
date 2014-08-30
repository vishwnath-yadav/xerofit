class LibraryVideo < ActiveRecord::Base
	belongs_to :library
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

  def panda_ogg
    self.panda_video.encodings['ogg']
  end

  def video_title
	self.panda_video.original_filename rescue ''
  end

end
