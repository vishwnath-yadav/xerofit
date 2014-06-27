class PandaVideoUpload < Struct.new(:video_id)
  
  def perform
  	Rails.logger.debug ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    video = LibraryVideo.find(video_id)
    Rails.logger.debug video.inspect
    if video.video_tmp.blank?
      p_video = Panda::Video.create!(source_url: video.video.to_s, path_format: "panda_video/:video_id/:profile/:id")
      video.update_attributes(panda_video_id: p_video.id)
      Rails.logger.debug video.panda_video_id
   	end
  end

end