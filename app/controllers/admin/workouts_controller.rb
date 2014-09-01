class Admin::WorkoutsController < ApplicationController

	def index
		@workout = Workout.all.order('created_at desc')
	end
	
end
