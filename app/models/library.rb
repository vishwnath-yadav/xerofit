class Library < ActiveRecord::Base
	belongs_to :user
	has_many :target_muscle_groups
	has_one :library_video
	has_one :library_detail
	has_many :library_blocks
	has_many :blocks, through: :library_blocks
	accepts_nested_attributes_for :target_muscle_groups

	validates :title, :directions, :category, :difficulty, presence: true
	
	CATEGORIES = ["Agility", "BodybuildingBodyweight","Cardio","Core","Dance","Dumbbell","Endurance","Exercise Ball","Kettlebell","Martial Arts","Medicine Ball","Office","Pilates","Playground","Postnatal","Prenatal","Pull Ups","Recovery","Resistance Bands","Stairs","Stretching","TRX","Warm Up","Yoga"]

	DIFFICULTIES = ["Beginner","Intermediate","Athletic","Elite"]

	def build_association
		1.times{target_muscle_groups.build if self.target_muscle_groups.empty? }
	end
end
