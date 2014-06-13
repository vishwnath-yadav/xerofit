class HomeController < ApplicationController
  def index

  end

  def create
    omniouth = request.env["omniauth.auth"]
    @user = User.from_omniauth(omniouth)
    sign_in :user, @user
    redirect_to root_path, notice: 'Signed in successfully!'
  end
  
end
