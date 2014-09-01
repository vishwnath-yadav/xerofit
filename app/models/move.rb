class Move < ActiveRecord::Base
	obfuscate_id :spin => 79678343
	
	# default_scope order('updated_at DESC')

	belongs_to :user
	has_many :target_muscle_groups
	has_one :library_video
	has_one :library_detail
	has_many :library_blocks
	has_many :blocks, through: :library_blocks
	
	after_create :save_status
	after_create :create_target_muscle_group

	accepts_nested_attributes_for :target_muscle_groups

	validates :title, presence: true

	validates :equipment, :length => { :maximum => 6, :message=>"size can not be greater than 5."}
	
	CATEGORIES = ["Agility", "Bodybuilding","Bodyweight","Cardio","Core","Dance","Dumbbell","Endurance","Exercise Ball","Kettlebell","Martial Arts","Medicine Ball","Office","Pilates","Playground","Postnatal","Prenatal","Pull Ups","Recovery","Resistance Bands","Stairs","Stretching","TRX","Warm Up","Yoga"]

	DIFFICULTIES = ["Beginner","Intermediate","Athletic","Elite"]
	
	EQUIPMENT_LIST = ["Ab Board","Adjustable Ab Board","Ankle Weights","Balance Beam","Balance Block","Balance Disc","Balance Dome (Bosu Ball)","Balance Pad","Barbell","Decline Bench","Dual Grip Medicine Ball","Dumbbells","Elliptical Machine","Exercise Ball (Swiss Ball)","Exercise Bike","Fit Chair","Fitness Tubes","Flat Band","Flat Bench","Foam Roller","Folding Mat","Incline Bench","Inflatable Pilates Ball Roller","Kettlebell","Medicine Ball","Mini Medicine Ball","Non-Bouncing Physical Therapy (P.T.) Ball","Pull Up Bar","Punching Bag","Resistance Band","Semi-Recumbent Ab Bench","Spin Style Bike","Stationary Bike","Suspension Trainer (TRX)","Treadmill","Upright Bike","Weighted Gloves","Weighted Vest","Wobble Board","Wrist Weights","Yoga Block"]

	STATUS = ["Approved and Active","Needs Attention","Waiting for Approval","Ready to Submit","Saved as Draft"]
	
	TYPE = ["Exercises", "Workouts"]

	scope :by_status, lambda { |status| where(status: status) unless status == "All Statuses" || status.blank? }
	scope :by_title, lambda { |title| where(title: title) unless title.blank? }
	scope :by_name, lambda { |name| where('title ilike ?', name+"%") unless name.blank? }
	scope :by_user, lambda { |user| where(user_id: user) unless user.blank? || user.nil? }
	scope :is_full_workout, lambda { |user| where(is_full_workout: false) unless user.blank? || user.nil? || user.admin? }

	def save_status
		self.status = STATUS[4]
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
		if params[:type] == "Workouts" 
			list = Workout.by_name(params[:title]).by_status(params[:status]).by_user(user).where(state: :completed).order("#{sort} #{order}")
		elsif params[:type] == "Moves"
			list = Move.by_name(params[:title]).by_status(params[:status]).by_user(user).is_full_workout(user).order("#{sort} #{order}")
		else
			list = Workout.by_name(params[:title]).by_status(params[:status]).by_user(user).where(state: :completed)
			list << Move.by_name(params[:title]).by_status(params[:status]).by_user(user).is_full_workout(user).all
			list = list.flatten
			if sort == "updated_at"
				list = order == "ASC" && list.size > 0 ? list.sort_by(&"#{sort}".to_sym) : list.sort_by(&"#{sort}".to_sym).reverse
			else
				list = order == "ASC" && list.size > 0 ? list.sort_by{|x| x["#{sort}".to_sym].downcase} : list.sort_by{|x| x["#{sort}".to_sym].downcase}.reverse
			end
		end
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

	def self.library_count
		self.all.count
	end

	def get_thumbnail
		if self.library_video.present? && self.library_video.panda_video.present? && self.library_video.panda_mp4.screenshots.present? && !self.library_video.image.present?
			self.library_video.image = self.library_video.panda_mp4.screenshots[0]
			self.library_video.save
		end
		size = []
		size1 = []
		if self.library_video.present? && self.library_video.panda_video.present? 
			size = self.library_video.panda_mp4.screenshots
			@image = self.library_video.image
			if size.include?(@image)
				index = size.index(@image)
				temp = size[index]
				size[index] = size[0]
				size[0] = temp
			end
			size1 = size	
		end
		size1.size > 6 ? size1.pop() : size1
		return size1
	end

	def has_full_detail
		if [self.status] & [STATUS[0],STATUS[2],STATUS[3]]
			return true
		else
			target_muscles =  self.target_muscle_groups.map(&:target_muscle_group) - [nil, ""]
			attributes = [self.title, self.directions, self.category, self.difficulty, self.status, self.equipment.join(",")]
			req = attributes & [nil, ""]
			req.size == 0 && target_muscles.size > 0 && self.is_thumbnail_created
		end
	end

	def is_thumbnail_created
		 self.library_video.present? && self.library_video.panda_video.present? && self.library_video.panda_mp4.screenshots.present?
	end

	def target_muscles
		self.target_muscle_groups
	end

	

end
