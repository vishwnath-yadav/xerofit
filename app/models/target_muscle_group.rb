class TargetMuscleGroup < ActiveRecord::Base
	belongs_to :move

	TARGET_FOR_SEARCH = ["Arms","Back","Chest","Core","Hips","Legs","Shoulders"]
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
