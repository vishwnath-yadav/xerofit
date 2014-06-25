class WorkoutBuildersController < ApplicationController
	before_filter :authenticate_user!
	def new
		@workout = WorkoutBuilder.new
		@libraries = Library.where(user_id: current_user.id)
	end

	def create
		@workout = WorkoutBuilder.new(workout_builder_params)
		@workout.user_id = current_user.id
		if @workout.save
		  redirect_to workout_builders_path
		else
		  render :new
		end
	end

	private
	  def workout_builder_params
	    params.require(:workout_builder).permit!
	  end
end
