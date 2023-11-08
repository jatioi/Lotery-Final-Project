class AdminsController < ApplicationController
  def sign_in
    admin = Admin.find_by(email: params[:email])

    if admin && admin.authenticate(params[:password])
      session[:admin_id] = admin.id
      redirect_to admin_welcome_path
    else
      flash[:alert] = "Invalid email or password"
      redirect_to root_path
    end
  end

  def welcome
    # Admin welcome page logic here
  end
end
