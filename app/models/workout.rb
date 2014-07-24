class Workout < ActiveRecord::Base

	has_attached_file :pic, :styles => { :medium => "300x300>", :thumb => "100x100>" ,:square => "30x30>"}, :default_url => "/images/:style/missing.png"
  	validates_attachment_content_type :pic, :content_type => /\Aimage\/.*\Z/
	
	has_many :blocks
	has_one :statastic
	belongs_to :user

	after_create :save_status
	
	validates :title, presence: true

	STATES = [:initiated, :completed]

	scope :by_status, lambda { |status| where(status: status) unless status == "All Status" || status.blank? }
	scope :by_name, lambda { |name| where('title ilike ?', name+"%") unless name.blank? }
  
	Workout::STATES.each do |state|
	    define_method "#{state}?" do
	      self.state.try(&:to_sym) == state
	    end
	end

	def save_blocks_and_libs(block_hash)
		block_hash.each do|key, value|
			block = Block.find(key)
			block.workout_id = self.id
			block.save!
			value.each do|k, v|
				lib = Library.find(k)
				lib_block = LibraryBlock.new(:library_id=>lib.id, :block_id=>block.id)
				lib_block.save!
				lib_detail = LibraryDetail.find(v)
				if lib_detail.present?
					lib_detail.library_block_id = lib_block.id
					lib_detail.save!
				end
			end
		end
	end

	def increase_visit
		if self.statastic.present?
			self.statastic.visits += 1
		else
			self.statastic = Statastic.new(visits: 1)
		end
		self.save
	end

	def most_popular
		Workout.joins(:statastic).where(state: "completed").order('statastics.visits DESC').limit(5)
	end

	def save_status
		self.status = Library::STATUS[0]
		self.save
	end
	
end
