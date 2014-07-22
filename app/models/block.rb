class Block < ActiveRecord::Base
	belongs_to :workout
	has_many :library_blocks
	has_many :libraries, through: :library_blocks

	BLOCK_TYPE = ["circuit","superset","individual"]

	def name_type
		if block_type == Block::BLOCK_TYPE[0]
			"3X"
		elsif block_type == Block::BLOCK_TYPE[1]
			"2X"
		elsif block_type == Block::BLOCK_TYPE[2]
			"1X"
		end
	end

	
end
