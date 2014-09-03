class FullWorkout < ActiveRecord::Base
	mount_uploader :video, VideoUploader
end
