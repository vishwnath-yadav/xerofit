class PasswordsController < Devise::PasswordsController
	
	def new
		super
	end	

	def edit
		super
	end	

	def create
		super
	end	

	def update
		super
	end

	protected
	  def after_sending_reset_password_instructions_path_for(resource_name)
	    reset_password_path
	  end
end