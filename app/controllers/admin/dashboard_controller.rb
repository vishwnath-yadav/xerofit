class Admin::DashboardController < Admin::AdminController
	def index
		 @user = User.all.order('created_at desc').limit(5)
		 @admin_count = User.admin_count
		 @trainer_count = User.trainer_count
		 @normaluser_count = User.user_count
		 @library_count = Library.library_count
		 @workout_count = Workout.workout_count
	end
end
