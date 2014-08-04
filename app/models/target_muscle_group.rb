class TargetMuscleGroup < ActiveRecord::Base
	belongs_to :library

	# MUSCLES_TYPE_OPT_1 = ["Arms", "Biceps", "Forearms", "Triceps"]
	# MUSCLES_TYPE_OPT_2 = ["Back", "Upper", "Lower", "Lats", "Traps", "Neck"]
	# MUSCLES_TYPE_OPT_3 = ["Chest", "Lower", "Upper", "Inner", "Outer"]
	# MUSCLES_TYPE_OPT_4 = ["Core", "Upper Abs", "Lower Abs", "Obliques"]
	# MUSCLES_TYPE_OPT_5 = ["Glutes"]
	# MUSCLES_TYPE_OPT_6 = ["Hips", "Hip Flexors", "Inside", "Outside"]
	# MUSCLES_TYPE_OPT_7 = ["Legs", "Calves", "Hamstrings", "Quadriceps"]
	# MUSCLES_TYPE_OPT_8 = ["Shoulders", "Anterior", "Posterior"]

	MUSCLES_TYPE_OPTION = {"Arms"=>["All Arms","Biceps", "Forearms", "Triceps"], 
						   "Back" => ["All Back","Upper", "Lower", "Lats", "Traps", "Neck"],
						   "Chest" => ["All Chest","Lower", "Upper", "Inner", "Outer"],
						   "Core" => ["All Core","Upper Abs", "Lower Abs", "Obliques"],
						   "Hips" =>["All Hips","Flexors", "Inside", "Outside"],
						   "Legs" =>["All Legs","Calves","Glutes", "Hamstrings", "Quadriceps"],
						   "Shoulders" => ["All Shoulders","Anterior", "Posterior"]}

	MUSCLES_TYPE = [["Primary",MUSCLES_TYPE_OPTION],
	 ["Secondary", MUSCLES_TYPE_OPTION], 
	 ["Other", MUSCLES_TYPE_OPTION],
	 ["Other", MUSCLES_TYPE_OPTION],
	 ["Other", MUSCLES_TYPE_OPTION]]

	 default_scope order('id ASC')
end
