class TargetMuscleGroup < ActiveRecord::Base
	belongs_to :library
	MUSCLES_TYPE = ["Primary Target", "Second Target", "Thired Target","Fouth Target","Fifth Target"]
end
