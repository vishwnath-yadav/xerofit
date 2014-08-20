class SettingsController < ApplicationController
	before_filter :authenticate_user!

	def index
	   @user = User.find(current_user.id)
	end

	def payment_billing
		@user = current_user
		@user.build_association
	end

	def subregion_options
	  render partial: 'subregion_select'
	end

	def save_payment_billing
		# binding.pry
		# current_user.subscriptions.new(params[:user][:subscriptions_attributes]["0"][:stripe_card_token])
		# current_user.addresses.new(params[:user][:addresses_attributes]["0"])
		# current_user.save
	    redirect_to :back
	end

	def save_user_pic
		@type = params[:type]
		if @type == "profile"
			@obj = User.find(params[:id])
		else
			@obj = Workout.find_by_id(params[:id])
		end
		if @obj.present?
			@obj.pic = params[:user][:pic]
			if @obj.save
				@success = true
			else
				@success = false
			end
		end
		respond_to do |format|
			format.js
		end
	end

	def change_password
		@user = User.find(current_user.id)
	end

	def update_password
		@user = User.find(current_user.id)
	    if @user.update_attributes(user_params)
	    	sign_in @user, :bypass => true
	        redirect_to settings_path, notice: "password is Successfully changed"
	    else
        	redirect_to change_password_settings_path
 		end

	end

	def update
		@user = User.find(params[:id])
        if @user.update_attributes(user_params)
		   @user.dob(params[:date][:day],params[:date][:month],params[:date][:year])
   	       redirect_to settings_path
	    end
	end

	def marketplace
	end

	
	private
	  def user_params
	    params.require(:user).permit!
	  end

end
