class Admin::UsersController < Admin::AdminController

	def index
		@users = User.all
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(permitted_user)
		if @user.save
		  redirect_to admin_users_path
		else
		  render action: 'new'
		end
	end

	def show
		@users = User.find(params[:id])
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		@user.skip_confirmation!
	    if @user.update_attributes(permitted_user)
	      redirect_to admin_users_path
	    else
	      render "edit"
	    end
	end

	def filter_user
		@users = User.by_email(params[:email]).by_role(params[:role]).all
		respond_to do |format|
			format.js
		end
	end

	private

	def permitted_user
		params.require(:user).permit(:fullname, :role, :email, :password)
	end

end
