class Admin::WorkoutsController < Admin::AdminController
    before_filter :authenticate_user!
    layout 'admin'

	def index
		@workout = Workout.all.order('created_at desc')
	end
	
end
