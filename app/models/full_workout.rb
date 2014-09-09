class FullWorkout < ActiveRecord::Base
	mount_uploader :video, VideoUploader

	belongs_to :user
	scope :by_mark_complete, lambda { |mark| where(mark_complete: mark) unless mark.blank? || mark.nil? }

	def self.get_workout_list(params,cur_user)
		if cur_user.admin? 
			enable = params[:enable].blank? ? true : false
			sort = params[:sorted_by].blank? ? "updated_at" : params[:sorted_by]
			order = params[:order].blank? ? "DESC" : params[:order]
			list = FullWorkout.by_mark_complete(params[:mark_complete]).where(enable: enable)
			if sort == "updated_at" || sort == "id"
				list = order == "ASC" && list.size > 0 ? list.sort_by(&"#{sort}".to_sym) : list.sort_by(&"#{sort}".to_sym).reverse
			elsif sort == "email"
				list = order == "ASC" && list.size > 0 ? list.sort_by{|x| x.user["#{sort}".to_sym].downcase} : list.sort_by{|x| x.user["#{sort}".to_sym].downcase}.reverse
			end
		end
		return list
	end

	def video_title
		self.video.file.filename.split('.')[0]
	end

	def video_size
		"%0.3f" % (self.video.size.to_f/1024/1024) 
	end

end
