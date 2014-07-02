class Workout < ActiveRecord::Base
	belongs_to :user
	has_many :blocks

	STATES = [:initiated, :completed]

	Workout::STATES.each do |state|
	    define_method "#{state}?" do
	      self.state.try(&:to_sym) == state
	    end
	end

	def save_blocks_and_libs(block_hash)
		block_hash.each do|key, value|
			block = Block.find(key)
			logger.debug("blcok #{block.id}")
			value.each do|k, v|
				lib = Library.find(k)
				logger.debug(">>>>>>>>>>>>>>>>")
				logger.debug(lib.id)
			end
		end
	end
	
end
