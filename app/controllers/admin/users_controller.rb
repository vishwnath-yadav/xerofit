class Admin::UsersController < Admin::AdminController

	def index
		@sort_array = User::USER_TYPE
		@users = User.where(enabled: true).order('created_at DESC')
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

	  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @user = User.find(params[:id])
    # authorize! :destroy, @post
    @user.destroy
    respond_to do |format|
      format.html { redirect_to admin_users_path}
      format.json { head :no_content }
    end
  end

	def filter_user
		sort = params[:sorted_by]
		@users = User.by_name(params[:name]).by_email(params[:email]).by_role(params[:role]).where(enabled: true).order("#{sort} DESC")
		respond_to do |format|
			format.js
		end
	end

	def user_trash
		user = User.find(params[:id])
		if user.present?
			user.enabled = false
			user.save
			user.moves.each do |move|
				move.enable = false
				move.save
			end	
			user.workouts.each do |work|
				work.enable = false
				work.save
			end
			user.full_workouts.each do |full_workout| 
				full_workout.enable = false
				full_workout.save
			end
		end
		redirect_to :back
	end

	private

	def permitted_user
		params.require(:user).permit(:first_name,:last_name, :role, :email, :password)
	end

end
