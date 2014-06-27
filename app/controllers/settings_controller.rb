class SettingsController < ApplicationController
	before_filter :authenticate_user!

	def edit_profile
		@user = User.find(current_user.id)
		Rails.logger.debug @user.inspect
	end

	def payment_billing
	end

	def change_password
	end

	def update
		Rails.logger.debug ">>>>>>>>>>>>>>"
		@user = User.find(params[:id])
        if @user.update_attributes(user_params)
	      redirect_to setting_edit_profile_path(params[:id])
	    end
	end

	private
	  def user_params
	    params.require(:user).permit!
	  end

end
