class Admin::WorkoutsController < Admin::AdminController
    before_filter :authenticate_user!

	def index
		@sort_array = Move::MOVE_TYPE
		parm = params.merge({type: Move::TYPE[1]}) 
		@moves = Move.get_library_list(parm,current_user,'', false)
	end

	def destroy
	    @work = Workout.find(params[:id])
	    @work.destroy
	    redirect_to :back
	end

end
