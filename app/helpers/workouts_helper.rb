module WorkoutsHelper

	def is_disabled(lib_detail)
		lib_detail.repetition.present? && lib_detail.repetition ? false : true
	end

	def is_duration(lib_detail)
		lib_detail.repetition && lib_detail.is_duration ? false : true
	end

	def is_tempo(lib_detail)
		lib_detail.repetition && lib_detail.is_tempo ? false : true
	end
end
