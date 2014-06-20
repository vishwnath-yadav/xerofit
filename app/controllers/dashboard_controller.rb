class DashboardController < ApplicationController
	before_filter :authenticate_user!

	# layout 'sub_menu_layout'

	def index
		render current_user.role
	end
	
	def create
	end
end
