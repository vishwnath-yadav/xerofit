class Admin::MovesController < Admin::AdminController

	def index
		@sort_array = Move::MOVE_TYPE
		parm = params.merge({type: Move::TYPE[0]}) 
		@moves = Move.get_library_list(parm,current_user,'', false)
	end 

	def edit
		@library = Move.find(params[:id])
		@disabled = ([@library.status] & [Move::STATUS[0],Move::STATUS[2]]).present?
		@max_size_allowed = @library.is_full_workout ? 1024 : 250
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
		@sort_array = Move::UNCUT_TYPE
		parm = params.merge({type: Move::TYPE[0]}) 
		@moves = Move.get_library_list(parm,current_user,'', true)
	end

	def approval_page
		@sort_array = Move::APPROVE_TYPE
		parm = params.merge({status: Move::STATUS[2], sorted_by: "date_submitted_for_approval", order: "ASC"}) 
		@moves = Move.get_library_list(parm,current_user,'', false)
	end

	def admin_filter
		is_full_workout = params[:is_full_workout].blank? ? false : true
		@moves = Move.get_library_list(params,current_user,'', params[:is_full_workout])
	end

	def mark_complete
		binding.pry
		move = Move.find_by_id(params[:id])
		move.mark_as = params[:mark_as] == 'true' ? true : false
		move.save
	end
end
