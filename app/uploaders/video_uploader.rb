class VideoUploader < UploaderBase

  def extension_white_list
    %w(mp4 webm ogg wmv)
  end

end
