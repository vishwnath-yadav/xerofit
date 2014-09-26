class MoveDetail < ActiveRecord::Base
	belongs_to :move_block
    validate :validate_workout

	REP = (0..60).to_a
	DURATION = ["Seconds", "Minutes", "Hours"]
	TEMPO = (0..5).to_a
	REP_TYPE = ["Repeat Until Failure","Number Range","Fixed Number"]
	DIST_OPT = ["Miles","Feet","Meters", "Kilometers"]

	def validate_workout
		if !(repetitions or distance  or duration or weight)
			self.errors.add(:base, "Atleast 1 of Repetitions, Weight, Distance and Duration field is required in order to save a workout")
		end
	end
end
