class Library < ActiveRecord::Base
	belongs_to :user
	has_many :target_muscle_groups
	has_one :library_video
	accepts_nested_attributes_for :target_muscle_groups

	validates :title, :directions, :category, :difficulty, presence: true
	
	def build_association
		1.times{target_muscle_groups.build if self.target_muscle_groups.empty? }
	end
end
