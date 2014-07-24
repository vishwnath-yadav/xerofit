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
	
	CATEGORIES = ["Agility", "BodybuildingBodyweight","Cardio","Core","Dance","Dumbbell","Endurance","Exercise Ball","Kettlebell","Martial Arts","Medicine Ball","Office","Pilates","Playground","Postnatal","Prenatal","Pull Ups","Recovery","Resistance Bands","Stairs","Stretching","TRX","Warm Up","Yoga"]

	DIFFICULTIES = ["Beginner","Intermediate","Athletic","Elite"]

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
