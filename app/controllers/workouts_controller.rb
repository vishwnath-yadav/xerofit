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
	end

	def create
		@workout = Workout.new(workout_params)
		@workout.user_id = @user.id
		@workout.save
		@workout.history_create()
		respond_to do |format|
			format.js
		end
	end

	def edit
		enabled_move = []
		disabled_move = []
		@workout = Workout.find(params[:id])
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
		# @block = Block.new(:name => "Individual", :block_type=> Block::BLOCK_TYPE[3])
		# @block.save
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


	def update_break_block_details
		if params[:block_id].present?
			@block = Block.find(params[:block_id])
			if params[:name] == "minutes"
					@block.minutes = params[:minute]
			elsif params[:name] == "seconds"
					@block.seconds = params[:second]
			end
			@block.save 
		end
		render text: true
	end

	def save_blocks
		@workout = Workout.find_by_id(params[:workout_id])
		if params[:block].present?
			block_hash = params[:block]
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
		if @lib_detail.present?
			@lib_detail.save
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
		# render text: true
		respond_to do |format|
			format.js 
		end
	end

	def create_workout_block
		if params[:drag_type] == "block"
			@block = Block.new(name: params[:block_name], :block_type=> params[:block_name])
			@block.save
			render json:{ id: @block.id}
		elsif params[:block_name] == Block::BLOCK_TYPE[3]
			@block = Block.new(name: params[:block_name],:block_type=> Block::BLOCK_TYPE[3])
			@block.save
			@lib_detail = MoveDetail.new()
			@lib_detail.save
			render json: {id: @block.id, lib_detail_id: @lib_detail.id}
		else
			@lib_detail = MoveDetail.new()
			if params[:sets].present? && params[:rest].present?
				@lib_detail.sets_count = params[:sets]
				@lib_detail.rest_time = params[:rest]
			end
			@lib_detail.save
			render json: {lib_detail_id: @lib_detail.id}
		end
	end

	def remove_block
		if params[:block_id].present?
			block = Block.find(params[:block_id])
			block.destroy
		end
		if params[:lib_detail_arr].present?
			lib_details = params[:lib_detail_arr]
			lib_details.each do |details_id|
				detail = MoveDetail.find(details_id)
				detail.destroy
			end
		end
		render text: true
	end
	# def create_workout_block
	# 	if params[:drag_type] == "block"
	# 		@block = Block.new(name: params[:block_name])
	# 		@block.save
	# 		render json:{ id: @block.id}
	# 	elsif params[:block_name] == Block::BLOCK_TYPE[3]
	# 		@block = Block.new(name: params[:block_name])
	# 		@block.save
	# 		@lib_detail = MoveDetail.new()
	# 		@lib_detail.save
	# 		render json: {id: @block.id, lib_detail_id: @lib_detail.id}
	# 	else
	# 		@lib_detail = MoveDetail.new()
	# 		@lib_detail.save
	# 		render json: {lib_detail_id: @lib_detail.id}
	# 	end
	# end

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
