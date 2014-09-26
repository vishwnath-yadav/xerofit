module Admin::MovesHelper

	def model_type
		if (action_name == "index" || action_name == "uncut_workout") && controller_name == "moves"
			return Move::TYPE[1]
		elsif action_name == "index" && controller_name == "workouts"
			return Move::TYPE[2]
		else
			return ""
		end
	end

end
