class Admin::WorkoutsController < Admin::AdminController
    before_filter :authenticate_user!

	def index
		@sort_array = Move::ADMIN_MOVE_FILTER
		parm = params.merge({type: Move::TYPE[1]}) 
		@moves = Move.get_library_list(parm,current_user,'')
	end

	def destroy
	    @work = Workout.find(params[:id])
	    @work.destroy
	    redirect_to :back
	end

end
