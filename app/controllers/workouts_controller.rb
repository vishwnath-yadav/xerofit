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
		@block = Block.new(:name => params[:title], :block_type=> params[:type])
		@block.save
		respond_to do |format|
			format.js 
		end
	end


	def save_blocks
		@workout = Workout.find(params[:workout_id])
		block_hash = params[:workout]
		@workout.save_blocks_and_libs(block_hash)
		redirect_to :back
	end

	def load_lib_details
		@lib_detail = params[:lib_detail].present? ? LibraryDetail.find(params[:lib_detail]) : nil
		if !@lib_detail.present?
			@lib_detail = LibraryDetail.new()
			@lib_detail.save
		end
		respond_to do |format|
			format.js 
		end
	end

	def save_lib_details
		lib_detail = LibraryDetail.find(params[:lib_detail_id])
		if lib_detail.present?
			lib_detail.update_attributes(library_detail_params)
		end
		render json: "success"
	end

	private
	  def workout_params
	    params.require(:workout).permit!
	  end

	  def library_detail_params
	  	params.require(:library_detail).permit!
	  end
end
