class ApplicationController < ActionController::Base
  before_action :set_current_user, if: :user_signed_in?
  
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  private

  def set_current_user
    Current.user = current_user
  end
end