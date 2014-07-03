class Block < ActiveRecord::Base
	belongs_to :workout
	has_many :library_blocks
	has_many :libraries, through: :library_blocks

	def name_type
		if block_type == "circuit"
			"3X"
		elsif block_type == "superset"
			"2X"
		elsif block_type == "individual"
			"1X"
		end
	end

	
end
