class Admin::MovesController < Admin::AdminController

	def index
		@sort_array = Move::ADMIN_MOVE_FILTER
		parm = params.merge({type: Move::TYPE[0]}) 
		@moves = Move.get_library_list(parm,current_user,'')
	end 

	def edit
		@library = Move.find(params[:id])
		@disabled = ([@library.status] & [Move::STATUS[0],Move::STATUS[2]]).present?
		@max_size_allowed = 250
		@size = @library.get_thumbnail()
		@count = @library.target_muscle_groups.collect{|t| t.target_muscle_group if t.target_muscle_group.blank?}.compact.count
		@lib_attr = (@library.title.present? && @library.directions.present? && @library.category.present? && @library.difficulty.present? && @library.library_video.image.present? && @count!=5)
	end

	def destroy
	    @move = Move.find(params[:id])
	    @move.destroy
	    redirect_to :back
	end

	def uncut_workout
		@sort_array = Move::ADMIN_UNCUT_FILTER
		parm = params.merge({type: Move::TYPE[0]}) 
		# @moves = Move.get_library_list(parm,current_user,'')
		@moves = FullWorkout.all.order('updated_at desc')
	end

	def approval_page
		@sort_array = Move::ADMIN_APPROVE_FILTER
		parm = params.merge({status: Move::STATUS[2], sorted_by: "date_submitted_for_approval", order: "ASC"}) 
		@moves = Move.get_library_list(parm,current_user,'')
	end

	def admin_filter
		if params[:action_name] == "uncut_workout"
			@moves = FullWorkout.get_workout_list(params,current_user)
		else
			@moves = Move.get_library_list(params,current_user,'')
		end
	end

	def mark_complete
		move = FullWorkout.find(params[:id])
		move.mark_complete = params[:mark_as] == 'true' ? true : false
		move.save
		render nothing: true
	end
end
