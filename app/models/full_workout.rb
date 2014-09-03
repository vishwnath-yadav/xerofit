class FullWorkout < ActiveRecord::Base
	mount_uploader :video, VideoUploader

	belongs_to :user
end
