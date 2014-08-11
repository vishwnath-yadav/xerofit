class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?
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

  def resolve_layout
    if current_user.admin?
      "admin"
    else
      "application"
    end
  end

  protected

  def layout_by_resource
    if devise_controller?
      "login"
    else
      "application"
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :fullname
    devise_parameter_sanitizer.for(:sign_up) << :role
  end

end
