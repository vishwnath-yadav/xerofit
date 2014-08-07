class Library < ActiveRecord::Base
	obfuscate_id :spin => 79678343

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
	
	EQUIPMENT_LIST = ["Ab Board","Adjustable Ab Board","Ankle Weights","Balance Beam","Balance Block","Balance Disc","Balance Dome (Bosu Ball)","Balance Pad","Barbell","Decline Bench","Dual Grip Medicine Ball","Dumbbells","Elliptical Machine","Exercise Ball (Swiss Ball)","Exercise Bike","Fit Chair","Fitness Tubes","Flat Band","Flat Bench","Foam Roller","Folding Mat","Incline Bench","Inflatable Pilates Ball Roller","Kettlebell","Medicine Ball","Mini Medicine Ball","Non-Bouncing Physical Therapy (P.T.) Ball","Pull Up Bar","Punching Bag","Resistance Band","Resistance Band","Semi-Recumbent Ab Bench","Spin Style Bike","Stationary Bike","Suspension Trainer (TRX)","Treadmill","Upright Bike","Weighted Gloves","Weighted Vest","Wobble Board","Wrist Weights","Yoga Block"]

	STATUS = ["Saved as Draft", "Waiting for Approval", "Approved and Active", "Needs Attention"]
	
	TYPE = ["Exercises", "Workouts"]

	scope :by_status, lambda { |status| where(status: status) unless status == "All Statuses" || status.blank? }
	scope :by_name, lambda { |name| where('title ilike ?', name+"%") unless name.blank? }
	scope :by_user, lambda { |user| where(user_id: user) unless user.blank? || user.nil? }

	def save_status
		self.status = STATUS[0]
		self.save
	end

	def previous_post
	  self.class.first(:conditions => ["id < ? and user_id = ?", id, self.user_id], :order => "id desc")
	end

	def next_post
	  self.class.first(:conditions => ["id > ? and user_id = ?", id,self.user_id], :order => "id asc")
	end

	def self.get_library_list(status,name,type,cur_user,param_user_id)
		if cur_user.admin? && param_user_id.present?
			list = list_view(status,name,type,param_user_id)
		elsif cur_user.admin?
			list = list_view(status,name,type,'')
		else	
			list = list_view(status,name,type,cur_user)
		end
		return list
	end

	def self.list_view(status,name,type,user)
		if type == "Workouts" 
			list = Workout.by_name(name).by_status(status).by_user(user).where(state: :completed)
		elsif type == "Moves"
			list = Library.by_name(name).by_status(status).by_user(user).all
		else
			list = Workout.by_name(name).by_status(status).by_user(user).where(state: :completed)
			list << Library.by_name(name).by_status(status).by_user(user).all
		end
		list.flatten
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
			TargetMuscleGroup.create(library_id: self.id, target_muscle_group: "")
		end
	end

	def self.library_count
		self.all.count
	end

	def get_thumbnail
		if self.library_video.panda_mp4.screenshots.present? && !self.library_video.image.present?
			self.library_video.image = self.library_video.panda_mp4.screenshots[0]
			self.library_video.save
		end
		size = []

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
end
