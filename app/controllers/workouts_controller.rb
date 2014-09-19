class WorkoutsController < ApplicationController
	before_filter :authenticate_user!
	before_action :fetch_user
	autocomplete :move, :title, :full => true
	layout :resolve_layout

	def new
		enabled_move = []
		disabled_move = []
		@workout = Workout.new()
		@moves = @user.single_moves
		if @moves.present?
			@moves.each do |move|
				res = move.has_full_detail
				if res == true
					enabled_move << move
				else
					disabled_move << move
				end
			end
			@enabled_move = enabled_move.flatten.sort_by(&:title)
			@disabled_move = disabled_move.flatten.sort_by(&:title)
		end
		@block = Block.new()
		@block.save
		@display = "block_hide"
	end

	def create
		@workout = Workout.new(workout_params)
		@workout.user_id = @user.id
		@workout.save
		@workout.history_create()
		#@workout = Workout.new
		respond_to do |format|
			format.js
		end
	end

	def edit
		@workout = Workout.find(params[:id])
		@block = Block.new(:name => "Individual", :block_type=> Block::BLOCK_TYPE[3])
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
				format.html { redirect_to libraries_path(user: @workout.user.token), :notice => 'Your changes have been saved' }
			else
				format.html { redirect_to libraries_path, :notice => 'Your changes have been saved' }
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
		@block = Block.new()
		@block.save
		@display = 'block_hide'
		respond_to do |format|
			format.js 
		end
	end

	def get_workout_water_sub_block
		@old_block_id = params[:id]
		@block = Block.new(name: Block::BLOCK_TYPE[2])
		@block.save
		respond_to do |format|
			format.js 
		end
	end

	def update_water_block_details
		if params[:block_id].present?
			@block = Block.find(params[:block_id])
			@block.minutes = params[:minute]
			@block.seconds = params[:second]
			@block.save 
		end
		render text: true
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
		@lib_detail = params[:lib_detail_id].present? ? MoveDetail.find(params[:lib_detail_id]) : nil
		if !@lib_detail.present?
			@lib_detail = MoveDetail.new()
			if params[:sets].present?
				@lib_detail.sets_count = params[:sets]
				@lib_detail.rest_time = params[:rests]
			end
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

	def update_move_details
		if params[:lib_detail_arr].present?
			lib_arr = params[:lib_detail_arr]
			lib_arr.each do |lib_detail|
				move_detail  = MoveDetail.find(lib_detail)
				if params[:name] == "sets_count"
						move_detail.sets_count = params[:value]
						move_detail.save 
				elsif params[:name] == "rest_time"
						move_detail.rest_time = params[:value]
						move_detail.save 
				end
			end
		end
		render text: true
	end

	def test
		enabled_move = []
		disabled_move = []
		@workout = Workout.new()
		@moves = @user.single_moves
		if @moves.present?
			@moves.each do |move|
				res = move.has_full_detail
				if res == true
					enabled_move << move
				else
					disabled_move << move
				end
			end
			@enabled_move = enabled_move.flatten.sort_by(&:title)
			@disabled_move = disabled_move.flatten.sort_by(&:title)
		end
		# @block = Block.new()
		# @block.save
		# @display = "block_hide"
	end


	def create_dragged_block
		# if params[:name].present?
		# 	@block = Block.new(block_type: params[:name])
		# else
		# 	@block = Block.new()
		# end
		# @block.save
		@block_name = params[:name]
		respond_to do |format|
			format.js 
		end 
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
