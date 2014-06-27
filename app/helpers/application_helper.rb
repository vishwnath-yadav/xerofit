module ApplicationHelper
	def get_bg
		if !current_user.present? && action_name != "trainers" && action_name != "home"
			return "home_bg size"
		end
	end
end
