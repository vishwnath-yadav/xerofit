class Admin::UsersController < Admin::AdminController

	def index
    @type = params[:type]
    @users = User.all
    @users = @users.where(role: @type) unless @type.blank?
  end

	def new
		@users = User.new
	end

  def create
    @users = User.new(permitted_user)
    @users.skip_confirmation!
    if @users.save!
      redirect_to admin_user_path(@users)
    else
      render action: 'new'
    end
  end

	def show
		@user = User.find(params[:id])
	end

  def enable
    change_account_state_to(:enable)
  end

  def disable
    change_account_state_to(:disable)
  end

	def change_account_state_to(state)
    @user = User.find(params[:id])
    @user.enabled = (state == :enable ? true : false)
    if @user.save
      redirect_to admin_user_path(@user), notice: "User was successfully #{state == :enable ? 'enabled' : 'disabled'}."
    else
      flash[:error] = "Unable to #{state == :enable ? 'enable' : 'disable'} user."
      redirect_to admin_user_path(@user)
    end
  end

	private

	def permitted_user
		params.require(:user).permit(:email, :fullname, :password, :role)
	end

end
