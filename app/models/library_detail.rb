class LibraryDetail < ActiveRecord::Base
	belongs_to :library_block
	REP = (0..60).to_a
	DURATION = ["Seconds", "Minutes", "Hours"]
	TEMPO = (0..5).to_a
	REP_TYPE = ["Range Of Reps"]
end
