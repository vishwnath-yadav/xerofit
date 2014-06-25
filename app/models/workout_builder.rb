class WorkoutBuilder < ActiveRecord::Base
	belongs_to :user
	has_many :block
end
