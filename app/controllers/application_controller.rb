class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :check_admin_mode

  def authenticate_active_admin_user!
  	authenticate_user!
  	unless current_user.admin?
  		flash[:alert] = "Unauthorized Access!"
  		redirect_to root_path
  	end
  end

  def after_sign_in_path_for(resource)
    vip_path
  end

  protected

  def check_admin_mode
  	if current_user
  		if ENV['ADMIN_MODE'] == true && controller_name != 'sessions' && !current_user.admin?
  			redirect_to '/maintenance.html'
  		end
  	else
  		if ENV['ADMIN_MODE'] == true && controller_name != 'sessions'
  			redirect_to '/maintenance.html'
  		end
  	end
  end
end
