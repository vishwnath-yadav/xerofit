class Block < ActiveRecord::Base
	belongs_to :workout

	def name_type
		if workout_type == "circuit"
			"3x"
		elsif workout_type == "superset"
			"2x"
		elsif workout_type == "individual"
			"1x"
		end
	end
end
