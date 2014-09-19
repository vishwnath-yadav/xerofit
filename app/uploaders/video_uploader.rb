class VideoUploader < UploaderBase

  def extension_white_list
    %w(mp4 webm ogg wmv mov avi 3gp mpg mpeg)
  end

  def fog_attributes
	  {'Content-Disposition' => 'attachment'}
	end

end
