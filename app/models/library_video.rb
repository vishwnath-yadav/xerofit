class LibraryVideo < ActiveRecord::Base
	belongs_to :library
	mount_uploader :video, VideoUploader
	store_in_background :video

	def panda_video
	  @panda_video ||= Panda::Video.find(panda_video_id)
	end

  def panda_mp4
    self.panda_video.encodings['h264']
  end

end
