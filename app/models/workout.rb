class Workout < ActiveRecord::Base
	belongs_to :user
	has_many :blocks

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
	
end
