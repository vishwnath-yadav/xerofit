class PandaVideoUpload < Struct.new(:video_id)
  
  def perform
    video = LibraryVideo.find(video_id)
    if video.video_tmp.blank?
      p_video = Panda::Video.create!(source_url: video.video.to_s, path_format: "panda_video/:video_id/:profile/:id")
      video.update_attributes(panda_video_id: p_video.id)
   	end
  end

end