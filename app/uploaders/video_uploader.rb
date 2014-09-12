class VideoUploader < UploaderBase

  def extension_white_list
    %w(mp4 webm ogg wmv)
  end

  def fog_attributes
	  {'Content-Disposition' => 'attachment'}
	end

end
