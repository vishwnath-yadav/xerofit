class Admin::DashboardController < Admin::AdminController

	def index
		 static = []
		 static << User.trainer_count
		 static << Move.move_count
		 static << Move.average_moves
		 
		 static << Move.approve_status_count
		 static << Move.attention_status_count
		 static << Move.waiting_status_count
		 static << Move.ready_status_count
		 static << Move.saved_status_count

		 static << Workout.workout_count
		 static << Workout.avg_workout_counts

		 static << Workout.approve_status_count
		 static << Workout.attention_status_count
		 static << Workout.waiting_status_count
		 static << Workout.ready_status_count
		 static << Workout.saved_status_count
		 

		 static << Move.video_process_count
		 static << 0

		 @statics = static.flatten
	end
end
