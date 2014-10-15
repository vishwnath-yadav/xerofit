class VideoInfo < ActiveRecord::Base
	belongs_to :move
	belongs_to :user

	def self.update_video_info(video_id, move, user)
		if video_id.present?
			video_info = VideoInfo.find(video_id)
			completed_video = VideoInfo.where(move_id: move.id, status: "completed")
			last_video_info = completed_video.order("updated_at asc")[completed_video.length - 1]

			if last_video_info.present?
				views_count = last_video_info.completed_video_views + 1
				video_info.update_attributes(completed_video_views: views_count, view_completed_time: DateTime.now, status: "completed")
			else
				views_count = 1
				video_info.update_attributes(completed_video_views: views_count, view_completed_time: DateTime.now, status: "completed")
			end
		else
				video_info = VideoInfo.new(move_id: move.id, user_id: user.id, view_start_time: DateTime.now, status: "playing")
				video_info.save
		end
		return video_info
	end
end
