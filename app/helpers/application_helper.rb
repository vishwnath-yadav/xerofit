module ApplicationHelper
	def get_bg
		if !current_user.present? && action_name != "trainers" && action_name != "home"
			return "home_bg size"
		end
	end

	def change_menu_title(controller_name)
		if controller_name == "libraries" || (controller_name == "workouts" && action_name == "workout_details")
			controller_name = "Fitness Library"
		elsif controller_name == "workouts"
			controller_name = "Workout Builder"
		elsif controller_name == "settings"
			controller_name = "Settings"
		else
			controller_name = "Home"
		end
	end
end
