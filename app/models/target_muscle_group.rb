class TargetMuscleGroup < ActiveRecord::Base
	belongs_to :library

	MUSCLES_TYPE_OPT_1 = ["Arms", "Biceps", "Forearms", "Triceps"]
	MUSCLES_TYPE_OPT_2 = ["Back", "Upper", "Lower", "Lats", "Traps", "Neck"]
	MUSCLES_TYPE_OPT_3 = ["Chest", "Lower", "Upper", "Inner", "Outer"]
	MUSCLES_TYPE_OPT_4 = ["Core", "Upper Abs", "Lower Abs", "Obliques"]
	MUSCLES_TYPE_OPT_5 = ["Glutes"]
	MUSCLES_TYPE_OPT_6 = ["Hips", "Hip Flexors", "Inside", "Outside"]
	MUSCLES_TYPE_OPT_7 = ["Legs", "Calves", "Hamstrings", "Quadriceps"]
	MUSCLES_TYPE_OPT_8 = ["Shoulders", "Anterior", "Posterior"]

	MUSCLES_TYPE = [["Primary Target",MUSCLES_TYPE_OPT_1],
	 ["Second Target", MUSCLES_TYPE_OPT_2], 
	 ["Third Target",MUSCLES_TYPE_OPT_3],
	 ["Fourth Target",MUSCLES_TYPE_OPT_4],
	 ["Fifth Target",MUSCLES_TYPE_OPT_5],
	 ["Sixth Target",MUSCLES_TYPE_OPT_6],
	 ["Seventh Target",MUSCLES_TYPE_OPT_7],
	 ["Eighth Target",MUSCLES_TYPE_OPT_8]]

end
