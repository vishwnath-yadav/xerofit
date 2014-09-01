class Block < ActiveRecord::Base
	belongs_to :workout
	has_many :library_blocks
	has_many :moves, through: :library_blocks

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

	def get_lib_detail(lib_id)
		LibraryBlock.where(block_id: self.id , move_id: lib_id).last.library_detail.id
	end
	
end
