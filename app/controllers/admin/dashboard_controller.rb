class Admin::DashboardController < Admin::AdminController

	def index
		 static = []
		 move_count = 0
		 workout_count = 0
		 approve_status_count = 0
		 attention_status_count = 0
		 waiting_status_count = 0
		 ready_status_count = 0
		 saved_status_count = 0
		 approve_status_count1 = 0
		 attention_status_count1 = 0
		 waiting_status_count1 = 0
		 ready_status_count1 = 0
		 saved_status_count1 = 0
		 trainers = User.where(role: 'trainer')

		 trainer_count = trainers.count
		 static << trainer_count
		 
		 trainers.each do |user|
		 	move_count = move_count + user.moves.count 
		 	approve_status_count = approve_status_count + user.moves.approve_status_count
		 	attention_status_count = attention_status_count + user.moves.attention_status_count
		 	waiting_status_count = waiting_status_count + user.moves.waiting_status_count
		 	ready_status_count = ready_status_count + user.moves.ready_status_count
		 	saved_status_count = saved_status_count + user.moves.saved_status_count

		 end

		 static << move_count
		 static << Move.average_moves(move_count, trainer_count)
		 static << approve_status_count
		 static << attention_status_count
		 static << waiting_status_count
		 static << ready_status_count
		 static << saved_status_count

		 trainers.each do |user|
		 	workout_count = workout_count + user.workouts.count
		 	approve_status_count1 = approve_status_count1 + user.workouts.approve_status_count
		 	attention_status_count1 = attention_status_count1 + user.workouts.attention_status_count
		 	waiting_status_count1 = waiting_status_count1 + user.workouts.waiting_status_count
		 	ready_status_count1 = ready_status_count1 + user.workouts.ready_status_count
		 	saved_status_count1 = saved_status_count1 + user.workouts.saved_status_count
		 end
		 static << workout_count
		 static << Workout.avg_workout_counts(workout_count,trainer_count)

		 static << approve_status_count1
		 static << attention_status_count1
		 static << waiting_status_count1
		 static << ready_status_count1
		 static << saved_status_count1

		 @statics = static.flatten

	end
end
