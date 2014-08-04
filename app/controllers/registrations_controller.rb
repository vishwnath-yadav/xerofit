class RegistrationsController < Devise::RegistrationsController
  # before_filter :configure_permitted_parameters, if: :devise_controller?
  
  def new
    super
  end

  def create
    super
  end

  def update
    super
  end

  def combo_signup
    build_resource({})
    respond_with self.resource
  end

  def users_sign_up_new
    @user = User.new
  end

  def users_sign_up_create
    @user = User.new(user_params)
    @user.password = "user1234"
    @user.enabled = false
    @user.skip_confirmation!
    if @user.save
      Emailer.user_registration_mail(@user.email).deliver
      redirect_to confirmation_home_index_path
    else
      render "users_sign_up_new"
    end
  end

  private
  def user_params
    params.require(:user).permit(:fullname, :email, :password, :role)
  end

end
