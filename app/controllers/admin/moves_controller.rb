class Admin::MovesController < ApplicationController
	def index
		@library = Move.all.order('created_at desc')
	end 

	def edit
	end
end
