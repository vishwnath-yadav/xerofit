module WorkoutsHelper

	def is_disabled(lib_detail)
		lib_detail.repetitions.present? && lib_detail.repetitions ? false : true
	end

	def is_duration(lib_detail)
		lib_detail.duration ? false : true
	end

	def is_tempo(lib_detail)
		lib_detail.tempo ? false : true
	end

	def is_distance(lib_detail)
		lib_detail.distance ? false : true
	end

	def is_weight(lib_detail)
		lib_detail.weight ? false : true
	end

	def is_set(lib_detail, type)
		if lib_detail.move_block.present?
			(lib_detail.move_block.block.name == Block::BLOCK_TYPE[3]) ? false : true
		elsif type == Block::BLOCK_TYPE[3]
			false
		else
			true
		end
	end

	def is_rest(lib_detail, type)
		if lib_detail.move_block.present?
			(lib_detail.move_block.block.name == Block::BLOCK_TYPE[3]) ? false : true
		elsif type == Block::BLOCK_TYPE[3]
			false
		else
			true
		end
	end
end
