class DashboardController < ApplicationController
	before_filter :authenticate_user!
    before_action :fetch_user, only: [:trainer]
    
    def index
    end

    def trainer
		
	end

	def create
        omniouth = request.env["omniauth.auth"]
        @user = User.from_omniauth(omniouth)
        if @user.enabled
            sign_in :user, @user
        	redirect_to root_path, notice: 'Welcome Back!'
        else
        	redirect_to new_user_session_path
        end
    end
end
