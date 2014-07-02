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
		Rails.logger.debug ">>>>>"
		@block = Block.new(:name => params[:title])
		@block.workout_type=params[:name]
		logger.debug(@block.inspect)
		respond_to do |format|
			if @block.save
				format.js 
			end
		end
	end


	def save_blocks
		Rails.logger.debug ">>>>>>>>>>>>>>>>>>"
		redirect_to :back
	end

	def marketplace
	end
	private
	  def workout_params
	    params.require(:workout).permit!
	  end
end
