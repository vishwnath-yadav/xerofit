class WorkoutsController < ApplicationController
	before_filter :authenticate_user!
	autocomplete :library, :title, :full => true
	layout :resolve_layout
	def new
		@workout = Workout.new
		@libraries = Library.where(user_id: current_user.id)
		@block = Block.new(:name => "Individual", :block_type=> Block::BLOCK_TYPE[2])
		@block.save
		@display = "block_hide"
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
		if params[:status] == Library::STATUS[1]
			@workout.status = Library::STATUS[1]	
		end
		@workout.update_attributes(workout_params)
		respond_to do |format|
			format.html { redirect_to :back}
			format.js {render 'create'}
		end
	end

	def destroy
		@workout = Workout.find(params[:id])
		@workout.state = Workout::STATES[0]
		@workout.save
		redirect_to libraries_path
	end


	def index
		@workouts = Workout.where(:state=>"completed")
	end

	def show
		@workout = Workout.find(params[:id])
		@workout.increase_visit
	end

	def get_workout_sub_block
		@block = Block.new(:name => params[:title], :block_type=> params[:type])
		@block.save
		@display = params[:display]
		respond_to do |format|
			format.js 
		end
	end


	def save_blocks
		@workout = Workout.find_by_id(params[:workout_id])
		if params[:workout].present?
			block_hash = params[:workout]
			@workout.save_blocks_and_libs(block_hash)
			@workout.state = "completed"
			@workout.save
		end
		redirect_to :back
	end

	def remove_library_from_block
		id = params[:lib_block].split("_")
		lib_block = LibraryBlock.where(block_id: id[0], library_id: id[1]).last
		lib_block.library_detail.destroy
		lib_block.destroy
		render text: true
	end


	def marketplace
	end

	def search_lib
		search_value = params[:search_value]
		filter_order = params[:order]
		if !search_value.blank?
			if filter_order == 'asc'
				@libraries = Library.where("title ILIKE ? and user_id = ?", "#{search_value}%", current_user.id).order('title ASC')
			else
				@libraries = Library.where("title ILIKE ? and user_id = ?", "#{search_value}%", current_user.id).order('title DESC')
			end
		else
			@libraries = Library.where("user_id = ?", current_user.id)
		end

		respond_to do |format|
			format.js 
		end
	end


	def load_lib_details
		@lib_detail = params[:lib_detail].present? ? LibraryDetail.find(params[:lib_detail]) : nil
		if !@lib_detail.present?
			@lib_detail = LibraryDetail.new()
			@lib_detail.save
		end
		if !params[:move].blank?
			block = Block.find(params[:block_id])
			block.move = params[:move]
			block.save
		end
		respond_to do |format|
			format.js 
		end
	end

	def save_lib_details
		@lib_detail = LibraryDetail.find(params[:lib_detail_id])
		if @lib_detail.present?
			@lib_detail.update_attributes(library_detail_params)
		end
		respond_to do |format|
			format.js {render 'load_lib_details.js.erb'}
		end
	end

	def workout_details
		@workouts = Workout.find(params[:id])
		@work = (@workouts.title.present? && @workouts.subtitle.present? && @workouts.description.present? && @workouts.category.present?)
	end

	private
	  def workout_params
	    params.require(:workout).permit!
	  end

	  def library_detail_params
	  	params.require(:library_detail).permit!
	  end
end
