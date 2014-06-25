class PandaVideoUpload < Struct.new(:video_id)
  
  def perform
    video = LibraryVideo.find(video_id)
    if video.video_tmp.blank?
    	Rails.logger.debug ">>>>>>>>>>>>>>>"
    	Rails.logger.debug video.inspect
      p_video = Panda::LibraryVideo.create!(source_url: video.video.to_s, path_format: "panda_video/:video_id/:profile/:id")
      Rails.logger.debug p_video.inspect
      video.update_attributes(panda_video_id: p_video.id)
      Rails.logger.debug video.inspect
   end
  end

end