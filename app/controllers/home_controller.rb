class HomeController < ApplicationController
  def index

  end

  def create
    omniouth = request.env["omniauth.auth"]
    @user = User.from_omniauth(omniouth)
    if @user.enabled
        sign_in :user, @user
    	redirect_to root_path, notice: 'Signed in successfully!'
    else
    	redirect_to new_user_session_path
    end
  end
  
end
