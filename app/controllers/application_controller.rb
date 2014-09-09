class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :check_admin_user_or_not
  
  layout :layout_by_resource

  def after_sign_in_path_for(resource)
    if resource.admin?
      '/admin'
    else
      trainer_dashboard_index_path
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def fetch_user
      token = params[:user]
      if User.where(:token => token).last.present?
        @user = User.where(token: token).first
      else
        @user = current_user
      end
  end

  protected

  def layout_by_resource
    if devise_controller?
      "login"
    elsif current_user.admin? && request.fullpath.match('/admin')
      "admin"
    else
      "application"
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :first_name
    devise_parameter_sanitizer.for(:sign_up) << :last_name
    devise_parameter_sanitizer.for(:sign_up) << :role
  end

  def check_admin_user_or_not
    if user_signed_in?
      if current_user.trainer?
        if request.fullpath.match('/admin')
          redirect_to libraries_path, :notice => "You are not Authorize for this page"
        end
      end
    end
  end
end
