class LibraryDetail < ActiveRecord::Base
	belongs_to :library_block

	validates :repetitions, presence: true

	REP = (0..60).to_a
	DURATION = ["Seconds", "Minutes", "Hours"]
	TEMPO = (0..5).to_a
	REP_TYPE = ["Repeat Until Failure","Number Range","Fixed Number"]
	DIST_OPT = ["Miles","Feets","Meters", "Kilometers"]
end
