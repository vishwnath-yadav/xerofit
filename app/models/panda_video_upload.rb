class PandaVideoUpload < Struct.new(:video_id)
  
  def perform
  	# Rails.logger.debug(">>>>>>>>>>>>>testing testing>>>>>>>>>>>>")
  	puts(">>>>>>>>>>>>>testing testing>>>>>>>>>>>>")
    video = LibraryVideo.find(video_id)
  	puts(">>>>>>>>>>>>>testisdfsdfsdfsdfsfsfsfsdfsfsdfsfsfsng testing>>>>>>>>>>>>")
    if video.video_tmp.blank?
      Rails.logger.debug(">>>>>>>>>>>>>testing testing>>>>>>>>>>>>")
      p_video = Panda::Video.create!(source_url: video.video.to_s, path_format: "panda_video/:video_id/:profile/:id")
      video.update_attributes(panda_video_id: p_video.id)
      Rails.logger.debug(">>>>>>>>>>>>>testing findshddd>>>>>>>>>>>>")
  		puts(">>>>>>>>>>>>>testinsdffsfsfsd>>>>>>>>>>>>")
   	end
  end

end