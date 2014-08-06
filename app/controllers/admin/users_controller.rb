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
	    if @user.update_attributes(permitted_user)
	      redirect_to admin_users_path
	    else
	      logger.debug(@user.errors.full_messages)
	      render "edit"
	    end
	end

	private

	def permitted_user
		params.require(:user).permit(:fullname, :role, :email, :password)
	end

end
