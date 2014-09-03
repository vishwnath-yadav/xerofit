class FullWorkout < ActiveRecord::Base
	mount_uploader :video, VideoUploader

	belongs_to :user

	def self.get_workout_list(params,cur_user)
		if cur_user.admin? 
			sort = params[:sorted_by].blank? ? "updated_at" : params[:sorted_by]
			order = params[:order].blank? ? "DESC" : params[:order]
			list = FullWorkout.all	
			if sort == "updated_at" || sort == "id"
				list = order == "ASC" && list.size > 0 ? list.sort_by(&"#{sort}".to_sym) : list.sort_by(&"#{sort}".to_sym).reverse
			elsif sort == "email"
				list = order == "ASC" && list.size > 0 ? list.sort_by{|x| x.user["#{sort}".to_sym].downcase} : list.sort_by{|x| x.user["#{sort}".to_sym].downcase}.reverse
			end
		end
		return list
	end

end
