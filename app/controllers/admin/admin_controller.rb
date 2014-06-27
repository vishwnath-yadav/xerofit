class Admin::AdminController < ApplicationController
	before_filter :authenticate_user!
	layout 'admin'
	# def set_use_default_layout
 #    	@use_default_layout = false
 #  	end
  
end
