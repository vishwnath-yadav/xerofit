class Move < ActiveRecord::Base
	obfuscate_id :spin => 79678343
	
	# default_scope order('updated_at DESC')

	belongs_to :user
	has_many :target_muscle_groups
	has_one :library_video
	has_one :move_detail
	has_many :video_infos
	has_many :move_blocks
	has_many :histories
	has_many :blocks, through: :move_blocks
	has_many :marketplace_moves
	has_many :marketplace_lists, through: :marketplace_moves

	after_create :save_status
	after_create :create_target_muscle_group
	# after_update :date_updated_for_approval

	accepts_nested_attributes_for :target_muscle_groups

	validates :title, presence: true

	validates :equipment, :length => { :maximum => 6, :message=>"size can not be greater than 5."}

	CATEGORIES = ["Agility", "Bodybuilding","Bodyweight","Cardio","Core","Dance","Dumbbell","Endurance","Exercise Ball","Kettlebell","Martial Arts","Medicine Ball","Office","Pilates","Playground","Postnatal","Prenatal","Pull Ups","Recovery","Resistance Bands","Stairs","Stretching","TRX","Warm Up","Yoga"]

	DIFFICULTIES = ["Beginner","Intermediate","Athletic","Elite"]

	EQUIPMENT_LIST = ["Ab Board","Adjustable Ab Board","Ankle Weights","Balance Beam","Balance Block","Balance Disc","Balance Dome (Bosu Ball)","Balance Pad","Barbell","Barbell Plates","Chair","Decline Bench","Dual Grip Medicine Ball","Dumbbells","Elliptical Machine","Exercise Ball (Swiss Ball)","Exercise Bike","Fitness Tubes","Flat Band","Flat Bench","Foam Roller","Folding Mat","Incline Bench","Inflatable Pilates Ball Roller","Kettlebell","Medicine Ball","Mini Medicine Ball","Non-Bouncing Physical Therapy (P.T.) Ball","Plates","Pull Up Bar","Punching Bag","Resistance Band","Semi-Recumbent Ab Bench","Spin Style Bike","Stationary Bike","Suspension Trainer (TRX)","Treadmill","Upright Bike","Weighted Gloves","Weighted Vest","Wobble Board","Wrist Weights","Yoga Block","Yoga Mat"]

	STATUS = ["Approved and Active","Needs Attention","Waiting for Approval","Ready to Submit","Saved as Draft"]

	ADMIN_MOVE_FILTER = [["Date Added", "updated_at"],["ID","id"],["Title","title"],["Status","status"],["User Email", "email"]]
	ADMIN_UNCUT_FILTER = [["Date Added/Uploaded","updated_at"],["ID","id"],["Email","email"]]
	ADMIN_APPROVE_FILTER = [["Date Submitted for Approval","updated_at"],["ID","id"],["Title","title"],["Content Type","move_type"],["Status","status"],["Email","email"]]
	ADMIN_TRASH_FILTER = [["Date Trashed","updated_at"],["ID","id"],["Title","title"],["Email","email"],["Content Type","move_type"]]
	ADMIN_UNCUT_TRASH_FILTER = [["Date Trashed","updated_at"],["ID","id"],["Email","email"]]
	ADMIN_STATISTICS = ['Trainer Count','Total number of moves','Average number of moves per trainer','Number of moves by Approved and Active','Number of moves by Needs Attention','Number of moves by Waiting for Approval','Number of moves by Ready to Submit','Number of moves by Saved as Draft','Number of total workouts','Average number of workouts per trainer','Number of workouts by Approved and Active','Number of workouts by Needs Attention','Number of workouts by Waiting for Approval','Number of workouts by Ready to Submit','Number of workouts by Saved as Draft']
	ADMIN_VIDEO_STATISTICS = ['Average video length in seconds','Average video size in megabytes','How long it takes to encode a video on panda','How many videos in the encoding queue on panda']
	TYPE = ["All Types", "Single Moves", "Workouts"]

	scope :by_status, lambda { |status| where(status: status) unless status == "All Statuses" || status.blank? }
	scope :by_name, lambda { |name| where('title ilike ?', name+"%") unless name.blank? }
	scope :by_user, lambda { |user| where(user_id: user) unless user.blank? || user.nil? }
	scope :by_category, lambda { |cat| where(category: cat) unless cat.blank? || cat.nil? }
	scope :by_target, lambda { |trgt| includes(:target_muscle_groups).where("target_muscle_groups.target_muscle_group=?", trgt).references(:target_muscle_groups) unless trgt.blank? || trgt.nil? }
	# scope :is_full_workout, lambda { |is_full_workout| where(is_full_workout: is_full_workout) if is_full_workout.present? }
	# scope :admin_full_workout, lambda { |user| where(is_full_workout: false) unless user.blank? || user.nil? || user.admin? }

	def save_status
		self.status = STATUS[4]
		self.move_type = Move::TYPE[1]
		self.save
	end

	# def previous_post
	#   self.class.first(:conditions => ["id < ? and user_id = ?", id, self.user_id], :order => "id desc")
	# end

	# def next_post
	#   self.class.first(:conditions => ["id > ? and user_id = ?", id,self.user_id], :order => "id asc")
	# end


	def self.get_library_list(params,cur_user,param_user_id)
		if cur_user.admin? && param_user_id.present?
			list = list_view(params,param_user_id)
		elsif cur_user.admin?
			list = list_view(params,'')
		else	
			list = list_view(params,cur_user)
		end
		return list
	end

	def self.list_view(params,user)
		sort = params[:sorted_by].blank? ? "updated_at" : params[:sorted_by]
		order = params[:order].blank? ? "DESC" : params[:order]
		enable = params[:enable].blank? ? true : false
		if params[:type] == TYPE[2] 
			list = Workout.by_name(params[:title]).by_status(params[:status]).by_user(user).where(state: :completed, enable: enable)
		elsif params[:type] == TYPE[1]
			list = Move.by_name(params[:title]).by_status(params[:status]).by_user(user).where(enable: enable)
		else
			list = Workout.by_name(params[:title]).by_status(params[:status]).by_user(user).where(state: :completed, enable: enable)
			list << Move.by_name(params[:title]).by_status(params[:status]).by_user(user).where(enable: enable).all
			list = list.flatten
		end
		if sort == "updated_at" || sort == "date_submitted_for_approval" || sort == "id"
			list = order == "ASC" && list.size > 0 ? list.sort_by(&"#{sort}".to_sym) : list.sort_by(&"#{sort}".to_sym).reverse
		elsif sort == "email"
			list = order == "ASC" && list.size > 0 ? list.sort_by{|x| x.user["#{sort}".to_sym].downcase} : list.sort_by{|x| x.user["#{sort}".to_sym].downcase}.reverse
		else
			list = order == "ASC" && list.size > 0 ? list.sort_by{|x| x["#{sort}".to_sym].downcase} : list.sort_by{|x| x["#{sort}".to_sym].downcase}.reverse
		end
		return list
	end

	def update_target_muscle(target_muscles)
		target_muscles.each do |k, v|
			if !v.has_key?("target_muscle_group")
				tmg = TargetMuscleGroup.where(id: v["id"]).last
				if tmg.present?
					tmg.destroy
				end
			end
		end
	end

	def create_target_muscle_group
		(1..5).each do |trg|
			TargetMuscleGroup.create(move_id: self.id, target_muscle_group: "")
		end
	end

	def self.move_count
		self.count
	end

	def get_thumbnail
		if self.library_video.present? && self.library_video.panda_video.present? && self.library_video.panda_mp4.screenshots.present? && !self.library_video.image.present?
			self.library_video.image = self.library_video.panda_thumbnail.screenshots[0]
			self.library_video.save
		end
		size = []
		size1 = []
		if self.library_video.present? && self.library_video.panda_video.present?
			size = self.library_video.panda_thumbnail.screenshots rescue []
			@image = self.library_video.image
			if size.include?(@image)
				index = size.index(@image)
				temp = size[index]
				size[index] = size[0]
				size[0] = temp
			end
			size1 = size
		end
		size1.size > 9 ? size1.pop() : size1
		return size1
	end

	def check_thumbnail
		if self.library_video.present? && self.library_video.image.present?
			return true
		elsif self.library_video.present? && self.library_video.panda_video.present? && self.library_video.panda_thumbnail.screenshots.present? && !self.library_video.image.present?
			self.library_video.image = self.library_video.panda_thumbnail.screenshots[0]
			self.library_video.save
			return true
		else
			return false
		end
	end

	def has_full_detail
		if [STATUS[0],STATUS[2],STATUS[3]].include? (self.status)
			return true
		else
			target_muscles =  self.target_muscle_groups.map(&:target_muscle_group) - [nil, ""]
			attributes = [self.title, self.directions, self.category, self.difficulty, self.status, self.equipment.join(",")]
			req = attributes & [nil, ""]
			req.size == 0 && target_muscles.size > 0 && self.is_thumbnail_created
		end
	end

	def is_thumbnail_created
		 self.library_video.present? && self.library_video.panda_video.present? && self.library_video.panda_thumbnail.screenshots.present?
	end

	def target_muscles
		self.target_muscle_groups
	end

	def date_updated_for_approval(new_status, old_status)
		if old_status != STATUS[2] && new_status == STATUS[2] && !self.date_submitted_for_approval.present?
			self.date_submitted_for_approval = self.updated_at
			self.save
			admin_emails = User.where(:role=> "admin").pluck(:email)
			Emailer.status_mail_to_admin(self, admin_emails).deliver
		end
		if old_status != new_status
			self.history_create()
		end
	end

	def history_create
		@history = History.new
	  	@history.move_id = self.id 
	  	@history.status = self.status
	  	@history.save 
	end

	def self.average_moves(move_count,trainer_count)
		if move_count != 0
			(move_count/trainer_count).to_i
		else 
			return 0
		end
	end

	def self.approve_status_count
		self.where(status: Move::STATUS[0]).count
	end

	def self.attention_status_count
		self.where(status: Move::STATUS[1]).count
	end

	def self.waiting_status_count
		self.where(status: Move::STATUS[2]).count
	end

	def self.ready_status_count
		self.where(status: Move::STATUS[3]).count
	end

	def self.saved_status_count
		self.where(status: Move::STATUS[4]).count
	end

	def self.video_process_count
		arr=[]
		moves = []
		video_length = 0
		video_size = 0
		video_encode = 0
		avg_video_length = 0
		avg_video_size = 0
		avg_encode_time = 0
		video_on_queue = 0
		trainers = User.where(role: 'trainer')
		trainers.each do |user|
 			moves << user.moves
		end
		move = moves.flatten
		if move.present?
			move.each do |mov|
			 	if mov.video_present
				 	video_length = video_length + mov.library_video.panda_video.duration
			        video_size = video_size + mov.library_video.panda_video.file_size
			 		if mov.library_video.panda_video.encodings.present? 
			 			if !mov.video_encoding_process
				    		video_encode = video_encode + mov.library_video.panda_video.encodings.map(&:encoding_time).sum()
			 			end   
			 			if mov.video_encoding_process
			 				video_on_queue = video_on_queue + 1
			 			end
			 		end
			 	end
			end
			avg_video_length = "%0.3f" % ((video_length/1000).to_f/Move.move_count)
			avg_video_size = "%0.3f" % ((video_size.to_f/1024/1024).to_f/Move.move_count)
			avg_encode_time = "%0.3f" % ((video_encode/4)/Move.move_count)
		end
		 arr << avg_video_length
		 arr << avg_video_size
		 arr << avg_encode_time
		 arr << video_on_queue
	end

	def market_place_list
		self.marketplace_lists.map(&:title).join(',') rescue '' 
	end

    def video_present
    	begin
			self.library_video.present? && self.library_video.panda_video.present?
		rescue
			return false
		end
    end

    def video_encoding_process
    	begin
    		 self.library_video.panda_video.encodings.map(&:status).include? "processing" 
       	rescue
    		return false
    	end
    end

end
