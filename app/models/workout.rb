class Workout < ActiveRecord::Base
	has_many :blocks
	has_one :statastic
	belongs_to :user

	validates :name, presence: true

	STATES = [:initiated, :completed]

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
	
end
