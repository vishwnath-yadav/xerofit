class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?
  # before_filter :set_use_default_layout

  # def set_use_default_layout
  #   @use_default_layout = true
  # end

  def after_sign_in_path_for(resource)
    logger.debug(">>>>>>>>>>>>>>>>>>>>login>>>>")
    if params[:admin_user].present?
      logger.debug(">>>>>>>>>>>>>>>>>>>>>>>>>>")
      logger.debug(">>>>>>>>>>>>>>>>>>>>>>>>>>")
      logger.debug(">>>>>>>>>>>>>>>>>>>>>>>>>>")
      logger.debug(">>>>>>>>>>>>>>>>>>>>>>>>>>")
      logger.debug(">>>>>>>>>>>>>>>>>>>>>>>>>>")
      admin_index_path
    else
      logger.debug("**************************")
      logger.debug("**************************")
      logger.debug("**************************")
      logger.debug("**************************")
      logger.debug("**************************")
      logger.debug("**************************")
      trainer_dashboard_index_path
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :fullname
    devise_parameter_sanitizer.for(:sign_up) << :role
  end


end
