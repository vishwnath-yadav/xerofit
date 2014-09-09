class Admin::DashboardController < Admin::AdminController

	def index
		 @statics = []
		 trainer_counts = User.trainer_count
		 @statics << trainer_counts
		 move_counts = Move.move_count
		 @statics << move_counts
		 avg_moves = (move_counts/trainer_counts).to_i
		 @statics << avg_moves
		 approve_counts = Move.where(status: Move::STATUS[0]).count
		 @statics << approve_counts
		 attention_counts = Move.where(status: Move::STATUS[1]).count
		 @statics << attention_counts
		 waiting_counts = Move.where(status: Move::STATUS[2]).count
		 @statics << waiting_counts
		 ready_counts = Move.where(status: Move::STATUS[3]).count
		 @statics << ready_counts
		 saved_counts = Move.where(status: Move::STATUS[4]).count
		 @statics << saved_counts
		 workout_counts = Workout.workout_count
		 @statics << workout_counts
		 avg_workout_counts = (workout_counts/trainer_counts).to_i
		 @statics << avg_workout_counts
		 video_length = 0
		 video_size = 0
		 video_encode = 0
		 move = Move.all
		 # move.each do |mov|
		 # 	video_length = video_length + mov.library_video.panda_video.encodings.map(&:duration).sum()
	  #       video_size = video_size + mov.library_video.video.size 
		 #    video_encode = video_encode + mov.library_video.panda_video.encodings.map(&:encoding_time).sum()
		 # end
		 # length_sec = video_length/1000
		 # size_mb =  video_size.to_f/1024/1024
		 # encode_time = video_encode/4
		 # avg_video_length = "%0.3f" % (length_sec.to_f/move_counts)
		 # avg_video_size = "%0.3f" % (size_mb.to_f/move_counts)
		 # avg_encode_time = "%0.3f" % (encode_time/move_counts)
		 @statics << 0
		 @statics << 0
		 @statics << 0
		 @statics << 0
	end
end
