class Library < ActiveRecord::Base
	belongs_to :user
	has_many :target_muscle_groups
	has_one :library_video
	has_one :library_detail
	has_many :library_blocks
	has_many :blocks, through: :library_blocks
	
	after_create :save_status

	accepts_nested_attributes_for :target_muscle_groups

	validates :title, presence: true

	validates :equipment, :length => { :maximum => 6, :message=>"size can not be greater than 5."}
	
	CATEGORIES = ["Agility", "Bodybuilding","Bodyweight","Cardio","Core","Dance","Dumbbell","Endurance","Exercise Ball","Kettlebell","Martial Arts","Medicine Ball","Office","Pilates","Playground","Postnatal","Prenatal","Pull Ups","Recovery","Resistance Bands","Stairs","Stretching","TRX","Warm Up","Yoga"]

	DIFFICULTIES = ["Beginner","Intermediate","Athletic","Elite"]
	
	EQUIPMENT_LIST = ["Ab Board","Adjustable Ab Board","Ankle Weights","Balance Beam","Balance Block","Balance Disc","Balance Dome (Bosu Ball)","Balance Pad","Barbell","Decline Bench","Dual Grip Medicine Ball","Dumbbells","Elliptical Machine","Exercise Ball (Swiss Ball)","Exercise Bike","Fit Chair","Fitness Tubes","Flat Band","Flat Bench","Foam Roller","Folding Mat","Incline Bench","Inflatable Pilates Ball Roller","Kettlebell","Medicine Ball","Mini Medicine Ball","Non-Bouncing Physical Therapy (P.T.) Ball","Pull Up Bar","Punching Bag","Resistance Band","Resistance Band","Semi-Recumbent Ab Bench","Spin Style Bike","Stationary Bike","Suspension Trainer (TRX)","Treadmill","Upright Bike","Weighted Gloves","Weighted Vest","Wobble Board","Wrist Weights","Yoga Block"]

	STATUS = ["Saved as Draft", "Waiting for Approval", "Approved and Active", "Needs Attention"]
	
	TYPE = ["Exercises", "Workouts"]

	scope :by_status, lambda { |status| where(status: status) unless status == "All Status" || status.blank? }
	scope :by_name, lambda { |name| where('title ilike ?', name+"%") unless name.blank? }
  

	def build_association
		1.times{target_muscle_groups.build if self.target_muscle_groups.empty? }
	end

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
end
