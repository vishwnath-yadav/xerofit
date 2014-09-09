class WorkoutsController < ApplicationController
	before_filter :authenticate_user!
	before_action :fetch_user
	autocomplete :move, :title, :full => true

	def new
		@workout = Workout.new()
		@moves = @user.single_moves
		@block = Block.new(:name => "Individual", :block_type=> Block::BLOCK_TYPE[2])
		@block.save
		@display = "block_hide"
	end

	def create
		@workout = Workout.new(workout_params)
		@workout.user_id = @user.id
		@workout.save
		@workout.histroy_create()
		#@workout = Workout.new
		respond_to do |format|
			format.js
		end
	end

	def edit
		@workout = Workout.find(params[:id])
		@block = Block.new(:name => "Individual", :block_type=> Block::BLOCK_TYPE[2])
		@block.save
		@display = "block_hide"
	end

	def update
		@workout = Workout.find(params[:id])
		old_status = @workout.status
		@workout.update_attributes(workout_params)
		@workout.date_updated_for_approval(params[:workout][:status], old_status)
		respond_to do |format|
			if current_user.admin?
				format.html { redirect_to libraries_path(user: @workout.user.token)}
			else
				format.html { redirect_to libraries_path}
			end
			format.js {render 'create'}
		end
	end

	def destroy
		@workout = Workout.find(params[:id])
		@workout.state = Workout::STATES[0]
		@workout.save
		redirect_to libraries_path
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
		flash[:notice] = "Workout Saved Successfully!"
		if current_user.admin?
			redirect_to libraries_path(user: @workout.user.token)
		else
			redirect_to libraries_path
		end
	end

	def remove_library_from_block
		id = params[:lib_block].split("_")
		move_block = Block.find_by_id(id[0])
		move_detail = MoveDetail.find_by_id(id[1])
		if move_block.present?
			move_block.destroy
		end
		if move_detail.present?  
			move_detail.destroy
		end
		render text: true
	end

	def load_lib_details
		@lib_detail = params[:lib_detail].present? ? MoveDetail.find(params[:lib_detail]) : nil
		if !@lib_detail.present?
			@lib_detail = MoveDetail.new()
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
		@lib_detail = MoveDetail.find(params[:lib_detail_id])
		if @lib_detail.present?
			@lib_detail.update_attributes(library_detail_params)
		end
		respond_to do |format|
			format.js {render 'load_lib_details.js.erb'}
		end
	end

	def workout_details
		@workout = Workout.find(params[:id])
		@user = @workout.user
		@disabled = ([@workout.status] & [Move::STATUS[0],Move::STATUS[2]]).present?
		@work = (@workout.title.present? && @workout.subtitle.present? && @workout.description.present? && @workout.category.present?)
	end

	private
	  def workout_params
	    params.require(:workout).permit!
	  end

	  def library_detail_params
	  	params.require(:move_detail).permit!
	  end

	  def resolve_layout
	    case action_name
	    when 'workout_details'
	      'application'
	    else
	      'workout_builder'
	    end
	  end

end
