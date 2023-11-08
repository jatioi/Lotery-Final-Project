# frozen_string_literal: true

class Admin::Users::SessionsController < Devise::SessionsController

  # before_action :configure_sign_in_params, only: [:create]
  before_action :authenticate_admin, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    super
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitiz
  # er.permit(:sign_in, keys: [:attribute])
  # end
  private

  def authenticate_admin
    user = User.find_by(email: params[:admin_user][:email])
    unless user && user.admin?
      flash[:alert] = "Access denied. You must be an admin to access this page."
      redirect_to admin_root_path
    end
  end
end
