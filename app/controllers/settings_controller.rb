class SettingsController < ApplicationController
	before_filter :authenticate_user!

	def edit_profile
		@user = User.find(current_user.id)
	end

	def payment_billing
		@address = Address.new
	end

	def subregion_options
	  render partial: 'subregion_select'
	end

	def save_payment_billing
		# Rails.logger.debug "????????????"
		# @user = current_user
		# #@sub = @user.subscriptions.new(params[:user][:subscription_attributes])
		# @add = @user.addresses.new(params[:user][:addresses_attributes]["0"])
		# @add.save!
		# logger.debug(">>>>>>>>>>>>>>>")
		# @subscription = Subscription.new(params[:stripe_card_token])
		# @subscription.user = current_user
	 #    @subscription.save_with_payment
		# Rails.logger.debug @subscription.inspect

	 #    @address = Address.find_by(user_id: current_user.id)
	 #    if @address.present?
	 #    	@address.update_attributes(country: params[:user][:addresses_attributes]['0'][:country],
	 #    						   address1: params[:user][:addresses_attributes]['0'][:address1],
	 #    						   address2: params[:user][:addresses_attributes]['0'][:address2], 
	 #    						   pin_code: params[:user][:addresses_attributes]['0'][:pin_code],
	 #    					       phone_number: params[:user][:addresses_attributes]['0'][:phone_number],
	 #    						   state: params[:address][:state])
	 #    else
	 #    	@address = Address.create(country: params[:user][:addresses_attributes]['0'][:country],
	 #    						   address1: params[:user][:addresses_attributes]['0'][:address1],
	 #    						   address2: params[:user][:addresses_attributes]['0'][:address2], 
	 #    						   pin_code: params[:user][:addresses_attributes]['0'][:pin_code],
	 #    					       phone_number: params[:user][:addresses_attributes]['0'][:phone_number],
	 #    						   state: params[:address][:state], user_id: current_user.id)
	 #    end
	 #    Rails.logger.debug @address.inspect
	    redirect_to :back
	end

	def change_password
		@user = User.find(current_user.id)
	end

	def changed_password
		logger.debug(">>>>>>>>>>");
		user = User.find(current_user.id)
	    if user.update(user_params)        # Sign in the user by passing validation in case his password changed
        	sign_in user, :bypass => true
	        redirect_to edit_profile_settings_path, notice: "password is Successfully changed"
	    else
        	redirect_to change_password_settings_path
 		end
	end

	def update
		@user = User.find(params[:id])
        if @user.update_attributes(user_params)
	      redirect_to edit_profile_settings_path
	    end
	end

	private
	  def user_params
	    params.require(:user).permit!
	  end

end
