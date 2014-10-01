class MoveDetail < ActiveRecord::Base
	belongs_to :move_block
    validate :validate_details

	REP = (0..60).to_a
	DURATION = ["Seconds", "Minutes", "Hours"]
	TEMPO = (0..5).to_a
	REP_TYPE = ["Repeat Until Failure","Number Range","Fixed Number"]
	DIST_OPT = ["Miles","Feet","Meters", "Kilometers"]

	def validate_details
		if !(repetitions or distance  or duration or weight)
			self.errors.add(:base, "Atleast 1 of the following sections is required: Repetitions, Weight, Distance, or Duration")
		elsif tempo && !(temp_lower > 0 or temp_pause > 0 or temp_lift > 0)
			self.errors.add(:base, "In the Tempo section at least one of the values for lower, pause, or lift must be greater than 0")
		end
	end
end
