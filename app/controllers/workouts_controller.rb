class WorkoutsController < ApplicationController
	before_filter :authenticate_user!
	def new
		@workout = Workout.new
		@libraries = Library.where(user_id: current_user.id)
	end

	def create
		@workout = Workout.new(workout_params)
		@workout.user_id = current_user.id
		@workout.save
		#@workout = Workout.new
		respond_to do |format|
			format.js
		end
	end

	def edit
		@workout = Workout.find(params[:id])
	end

	def update
		@workout = Workout.find(params[:id])
		@workout.update_attributes(workout_params)
		respond_to do |format|
			format.js {render 'create'}
		end
	end

	def get_workout_sub_block
		respond_to do |format|
			format.js
		end
	end

	private
	  def workout_params
	    params.require(:workout).permit!
	  end
end
