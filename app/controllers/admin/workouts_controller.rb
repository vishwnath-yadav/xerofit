class Admin::WorkoutsController < ApplicationController

	def index
		parm = params.merge({type: Move::TYPE[1]}) 
		@moves = Move.get_library_list(parm,current_user,'', false)
	end
	
end
